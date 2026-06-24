#!/usr/bin/env python3
import argparse
import html
import json
import os
import re
import sys
from urllib.error import HTTPError, URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen


DEFAULT_RSSHUB_BASE = "https://rsshub.rssforever.com"
CHANNEL_ID_RE = re.compile(r"^UC[A-Za-z0-9_-]{22}$")


def normalize_rsshub_base(base):
    return base.rstrip("/")


def rsshub_feed_url(channel_id, base):
    return f"{normalize_rsshub_base(base)}/youtube/channel/{channel_id}"


def direct_youtube_feed_url(channel_id):
    return f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}"


def channel_id_from_url(url):
    parsed = urlparse(url)
    path_parts = [part for part in parsed.path.split("/") if part]
    if len(path_parts) >= 2 and path_parts[0] == "channel" and CHANNEL_ID_RE.match(path_parts[1]):
        return path_parts[1]
    return None


def fetch_page(url):
    request = Request(
        url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
                "(KHTML, like Gecko) Chrome/125.0 Safari/537.36"
            ),
            "Accept-Language": "en-US,en;q=0.8",
        },
    )
    with urlopen(request, timeout=20) as response:
        return response.read().decode("utf-8", errors="replace")


def find_balanced_json_after(source, marker):
    marker_index = source.find(marker)
    if marker_index == -1:
        return None

    start = source.find("{", marker_index + len(marker))
    if start == -1:
        return None

    in_string = False
    escaping = False
    depth = 0
    for index in range(start, len(source)):
        char = source[index]
        if in_string:
            if escaping:
                escaping = False
            elif char == "\\":
                escaping = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return source[start : index + 1]

    return None


def extract_channel_id_from_jsonish(source):
    for marker in ("ytInitialData", "ytInitialPlayerResponse"):
        json_text = find_balanced_json_after(source, marker)
        if not json_text:
            continue
        try:
            value = json.loads(json_text)
        except json.JSONDecodeError:
            continue
        channel_id = find_channel_id_in_value(value)
        if channel_id:
            return channel_id
    return None


def find_channel_id_in_value(value):
    if isinstance(value, dict):
        for key in ("channelId", "externalId", "browseId"):
            maybe_channel_id = value.get(key)
            if isinstance(maybe_channel_id, str) and CHANNEL_ID_RE.match(maybe_channel_id):
                return maybe_channel_id
        for child in value.values():
            channel_id = find_channel_id_in_value(child)
            if channel_id:
                return channel_id
    elif isinstance(value, list):
        for child in value:
            channel_id = find_channel_id_in_value(child)
            if channel_id:
                return channel_id
    return None


def extract_channel_id_from_html(source):
    source = html.unescape(source)

    patterns = [
        r'<meta\s+itemprop=["\']channelId["\']\s+content=["\'](UC[A-Za-z0-9_-]{22})["\']',
        r'<link\s+rel=["\']canonical["\']\s+href=["\']https://www\.youtube\.com/channel/(UC[A-Za-z0-9_-]{22})["\']',
        r'"channelId"\s*:\s*"(UC[A-Za-z0-9_-]{22})"',
        r'"externalId"\s*:\s*"(UC[A-Za-z0-9_-]{22})"',
        r'"browseId"\s*:\s*"(UC[A-Za-z0-9_-]{22})"',
    ]
    for pattern in patterns:
        match = re.search(pattern, source)
        if match:
            return match.group(1)

    return extract_channel_id_from_jsonish(source)


def find_channel_id(url):
    channel_id = channel_id_from_url(url)
    if channel_id:
        return channel_id

    source = fetch_page(url)
    channel_id = extract_channel_id_from_html(source)
    if channel_id:
        return channel_id

    raise RuntimeError("Could not find a YouTube channel ID in the fetched page")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Print the RSSHub YouTube channel feed URL for a YouTube URL."
    )
    parser.add_argument("youtube_url", help="YouTube channel, handle, video, short, or youtu.be URL")
    parser.add_argument(
        "--rsshub-base",
        default=os.environ.get("RSSHUB_BASE", DEFAULT_RSSHUB_BASE),
        help=f"RSSHub base URL. Defaults to RSSHUB_BASE or {DEFAULT_RSSHUB_BASE}",
    )
    parser.add_argument(
        "--direct",
        action="store_true",
        help="Print YouTube's direct RSS feed instead of the RSSHub route",
    )
    parser.add_argument(
        "--show-id",
        action="store_true",
        help="Print the resolved channel ID before the feed URL",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    try:
        channel_id = find_channel_id(args.youtube_url)
    except HTTPError as e:
        print(f"Failed to fetch YouTube page: HTTP {e.code}", file=sys.stderr)
        return 1
    except URLError as e:
        print(f"Failed to fetch YouTube page: {e.reason}", file=sys.stderr)
        return 1
    except TimeoutError:
        print("Failed to fetch YouTube page: timed out", file=sys.stderr)
        return 1
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
        return 1

    if args.show_id:
        print(channel_id)

    if args.direct:
        print(direct_youtube_feed_url(channel_id))
    else:
        print(rsshub_feed_url(channel_id, args.rsshub_base))

    return 0


if __name__ == "__main__":
    sys.exit(main())
