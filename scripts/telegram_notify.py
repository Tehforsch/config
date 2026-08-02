#!/usr/bin/env python3
"""Select a Telegram chat and notify once about its next new message."""

import argparse
import asyncio
from dataclasses import dataclass
import html
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time


APP_NAME = "telegram_notify"
CREDENTIALS_FILE = Path.home() / "resource/keys/telegram/notify.yml"
WATCHER_METADATA_VERSION = 2


@dataclass(frozen=True)
class Watcher:
    pid: int
    process_start_time: str
    chat_name: str
    peer_id: int
    metadata_path: Path
    metadata_version: int


def state_dir() -> Path:
    base = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    return base / APP_NAME


def watchers_dir() -> Path:
    return state_dir() / "watchers"


def get_process_start_time(pid: int) -> str | None:
    try:
        # Field 22 follows the process name in parentheses, which may contain spaces.
        fields = Path(f"/proc/{pid}/stat").read_text().rsplit(")", 1)[1].split()
        if fields[0] == "Z":
            return None
        return fields[19]
    except (FileNotFoundError, IndexError, PermissionError):
        return None


def remove_watcher_metadata(watcher: Watcher) -> None:
    try:
        data = json.loads(watcher.metadata_path.read_text())
        if (
            int(data.get("pid")) == watcher.pid
            and str(data.get("process_start_time")) == watcher.process_start_time
            and int(data.get("peer_id")) == watcher.peer_id
        ):
            watcher.metadata_path.unlink(missing_ok=True)
    except (TypeError, ValueError, FileNotFoundError, json.JSONDecodeError, OSError):
        pass


def register_watcher(
    chat_name: str,
    peer_id: int,
    *,
    pid: int | None = None,
    process_start_time: str | None = None,
) -> Watcher:
    directory = watchers_dir()
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    pid = os.getpid() if pid is None else pid
    current_start_time = get_process_start_time(pid)
    if process_start_time is None:
        process_start_time = current_start_time
    elif current_start_time != process_start_time:
        raise RuntimeError("The Telegram watcher process is no longer running.")
    if process_start_time is None:
        raise RuntimeError("Could not identify the watcher process.")

    metadata_path = directory / f"{peer_id}.json"
    temporary_path = directory / f".{peer_id}.{os.getpid()}.{time.time_ns()}.tmp"
    descriptor = os.open(
        temporary_path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600
    )
    try:
        with os.fdopen(descriptor, "w") as metadata_file:
            json.dump(
                {
                    "version": WATCHER_METADATA_VERSION,
                    "pid": pid,
                    "process_start_time": process_start_time,
                    "chat_name": chat_name,
                    "peer_id": peer_id,
                },
                metadata_file,
            )
            metadata_file.write("\n")
        temporary_path.replace(metadata_path)
    finally:
        temporary_path.unlink(missing_ok=True)

    return Watcher(
        pid,
        process_start_time,
        chat_name,
        peer_id,
        metadata_path,
        WATCHER_METADATA_VERSION,
    )


def unregister_watcher(watcher: Watcher) -> None:
    for active_watcher in active_watchers():
        if (
            active_watcher.pid == watcher.pid
            and active_watcher.process_start_time == watcher.process_start_time
        ):
            remove_watcher_metadata(active_watcher)


def active_watchers() -> list[Watcher]:
    active = []
    try:
        metadata_paths = sorted(watchers_dir().glob("*.json"))
    except OSError:
        return active

    for metadata_path in metadata_paths:
        try:
            data = json.loads(metadata_path.read_text())
            pid = int(data["pid"])
            process_start_time = str(data["process_start_time"])
            chat_name = str(data["chat_name"])
            peer_id = int(data["peer_id"])
            metadata_version = int(data.get("version", 1))
            if get_process_start_time(pid) != process_start_time:
                try:
                    metadata_path.unlink(missing_ok=True)
                except OSError:
                    pass
                continue
            active.append(
                Watcher(
                    pid,
                    process_start_time,
                    chat_name,
                    peer_id,
                    metadata_path,
                    metadata_version,
                )
            )
        except (KeyError, TypeError, ValueError, json.JSONDecodeError, OSError):
            try:
                metadata_path.unlink(missing_ok=True)
            except OSError:
                pass

    return active


def clear_watchers() -> int:
    watchers = active_watchers()
    processes = {
        (watcher.pid, watcher.process_start_time): watcher for watcher in watchers
    }
    for watcher in processes.values():
        try:
            os.kill(watcher.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass

    deadline = time.monotonic() + 2
    while time.monotonic() < deadline:
        if all(
            get_process_start_time(watcher.pid) != watcher.process_start_time
            for watcher in processes.values()
        ):
            break
        time.sleep(0.05)

    for watcher in processes.values():
        if get_process_start_time(watcher.pid) == watcher.process_start_time:
            try:
                os.kill(watcher.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass

    for watcher in watchers:
        remove_watcher_metadata(watcher)

    return len(watchers)


def watcher_status() -> str:
    chats = {
        watcher.peer_id: watcher.chat_name for watcher in active_watchers()
    }
    return ", ".join(sorted(chats.values(), key=str.casefold))


def credentials() -> tuple[int, str]:
    import yaml

    try:
        data = yaml.safe_load(CREDENTIALS_FILE.read_text())
    except FileNotFoundError as error:
        raise RuntimeError(f"Credentials file not found: {CREDENTIALS_FILE}") from error
    except yaml.YAMLError as error:
        raise RuntimeError(f"Invalid YAML in {CREDENTIALS_FILE}: {error}") from error

    if not isinstance(data, dict):
        raise RuntimeError(f"Expected a YAML mapping in {CREDENTIALS_FILE}.")

    api_id = data.get("api_id")
    api_hash = data.get("api_hash")
    if api_id is None or api_hash is None:
        raise RuntimeError(
            f"{CREDENTIALS_FILE} must contain api_id and api_hash keys."
        )

    try:
        parsed_api_id = int(api_id)
    except (TypeError, ValueError) as error:
        raise RuntimeError(f"api_id in {CREDENTIALS_FILE} must be an integer.") from error

    if not isinstance(api_hash, str) or not api_hash.strip():
        raise RuntimeError(f"api_hash in {CREDENTIALS_FILE} must be a string.")

    return parsed_api_id, api_hash.strip()


def load_session() -> str:
    path = state_dir() / "session"
    try:
        return path.read_text().strip()
    except FileNotFoundError:
        return ""


def save_session(value: str) -> None:
    directory = state_dir()
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    path = directory / "session"
    temporary_path = directory / "session.tmp"

    descriptor = os.open(temporary_path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(descriptor, "w") as session_file:
        session_file.write(value)
        session_file.write("\n")
    temporary_path.replace(path)


def require_command(name: str) -> None:
    if shutil.which(name) is None:
        raise RuntimeError(f"Required command not found: {name}")


def display_name(entity: object) -> str:
    from telethon import utils

    name = utils.get_display_name(entity) or "Unnamed chat"
    return " ".join(name.split())


async def choose_chat(api_id: int, api_hash: str) -> tuple[int, str] | None:
    from telethon import TelegramClient
    from telethon.sessions import StringSession

    client = TelegramClient(StringSession(load_session()), api_id, api_hash)
    try:
        # The first run prompts for the phone number, login code, and 2FA password.
        await client.start()
        save_session(client.session.save())

        dialogs = [
            dialog
            async for dialog in client.iter_dialogs()
            if dialog.is_user or dialog.is_group
        ]
        if not dialogs:
            raise RuntimeError("No private chats or groups were found.")

        rows = []
        for index, dialog in enumerate(dialogs):
            kind = "user" if dialog.is_user else "group"
            username = getattr(dialog.entity, "username", None)
            suffix = f"  @{username}" if username else ""
            rows.append(f"{index}\t{kind}\t{display_name(dialog.entity)}{suffix}")

        result = subprocess.run(
            [
                "fzf",
                "--delimiter=\t",
                "--with-nth=2..",
                "--prompt=Telegram chat> ",
                "--height=80%",
                "--reverse",
            ],
            input="\n".join(rows),
            text=True,
            stdout=subprocess.PIPE,
            check=False,
        )
        if result.returncode in (1, 130) or not result.stdout.strip():
            return None
        if result.returncode != 0:
            raise RuntimeError(f"fzf exited with status {result.returncode}.")

        selected = dialogs[int(result.stdout.split("\t", 1)[0])]
        username = getattr(selected.entity, "username", None)
        chat_name = f"@{username}" if selected.is_user and username else display_name(
            selected.entity
        )
        return selected.id, chat_name
    finally:
        await client.disconnect()


def message_text(event: object) -> str:
    text = event.raw_text.strip()
    if not text:
        text = "[Media message]" if event.message.media else "[Service message]"
    if len(text) > 500:
        text = text[:497] + "..."
    return text


async def watch_chat(
    peer_id: int, chat_name: str, api_id: int, api_hash: str
) -> None:
    from telethon import events, TelegramClient
    from telethon.sessions import StringSession

    session = load_session()
    if not session:
        raise RuntimeError("No Telegram session exists; run the script interactively first.")

    client = TelegramClient(StringSession(session), api_id, api_hash)
    watcher = register_watcher(chat_name, peer_id)
    notifications_in_progress: set[int] = set()
    try:
        await client.connect()
        if not await client.is_user_authorized():
            raise RuntimeError("The saved Telegram session is no longer authorized.")

        @client.on(events.NewMessage(incoming=True))
        async def on_new_message(event: object) -> None:
            if event.chat_id in notifications_in_progress:
                return

            watched_chat = next(
                (
                    candidate
                    for candidate in active_watchers()
                    if candidate.pid == watcher.pid
                    and candidate.process_start_time == watcher.process_start_time
                    and candidate.peer_id == event.chat_id
                ),
                None,
            )
            if watched_chat is None:
                return

            notifications_in_progress.add(event.chat_id)
            notification_sent = False
            try:
                chat = await event.get_chat()
                sender = await event.get_sender()
                notification_chat_name = display_name(chat)
                sender_name = (
                    display_name(sender) if sender is not None else "Unknown sender"
                )
                body = message_text(event)

                if event.is_group:
                    body = f"{sender_name}: {body}"

                result = subprocess.run(
                    [
                        "notify-send",
                        "--app-name=Telegram",
                        "--icon=telegram",
                        "--expire-time=3600000",
                        f"Telegram — {notification_chat_name}",
                        html.escape(body),
                    ],
                    check=False,
                )
                if result.returncode != 0:
                    print(
                        f"notify-send exited with status {result.returncode}.",
                        flush=True,
                    )
                    return

                remove_watcher_metadata(watched_chat)
                notification_sent = True
                print(
                    f"Notified once for Telegram peer {event.chat_id}; "
                    "stopped watching it.",
                    flush=True,
                )
            finally:
                notifications_in_progress.discard(event.chat_id)
                if notification_sent and not any(
                    candidate.pid == watcher.pid
                    and candidate.process_start_time == watcher.process_start_time
                    for candidate in active_watchers()
                ):
                    asyncio.ensure_future(client.disconnect())

        print(f"Watching Telegram peer {peer_id} for one message.", flush=True)
        await client.run_until_disconnected()
    finally:
        await client.disconnect()
        unregister_watcher(watcher)


def start_background_watcher(peer_id: int, chat_name: str) -> None:
    watchers = active_watchers()
    processes = {
        (watcher.pid, watcher.process_start_time) for watcher in watchers
    }
    if (
        watchers
        and len(processes) == 1
        and all(
            watcher.metadata_version == WATCHER_METADATA_VERSION
            for watcher in watchers
        )
    ):
        owner = watchers[0]
        already_watched = any(watcher.peer_id == peer_id for watcher in watchers)
        register_watcher(
            chat_name,
            peer_id,
            pid=owner.pid,
            process_start_time=owner.process_start_time,
        )
        if already_watched:
            print(f"Already watching {chat_name} for one message (PID {owner.pid}).")
        else:
            print(
                f"Added {chat_name} to Telegram watcher PID {owner.pid} "
                "for one message."
            )
        return

    subscriptions = {watcher.peer_id: watcher.chat_name for watcher in watchers}
    subscriptions[peer_id] = chat_name
    if watchers:
        clear_watchers()
        print(
            "Migrating existing chat subscriptions to one Telegram watcher."
        )

    directory = state_dir()
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    log_path = directory / "watcher.log"

    with log_path.open("ab", buffering=0) as log_file:
        process = subprocess.Popen(
            [
                sys.executable,
                str(Path(__file__).resolve()),
                "--watch",
                str(peer_id),
                f"--chat-name={chat_name}",
            ],
            stdin=subprocess.DEVNULL,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )

    process_start_time = get_process_start_time(process.pid)
    if process_start_time is None:
        raise RuntimeError("The Telegram watcher failed to start.")

    for subscription_peer_id, subscription_chat_name in subscriptions.items():
        register_watcher(
            subscription_chat_name,
            subscription_peer_id,
            pid=process.pid,
            process_start_time=process_start_time,
        )

    watched_names = sorted(subscriptions.values(), key=str.casefold)
    print(
        f"Watching {', '.join(watched_names)} for one message each in the background "
        f"(PID {process.pid})."
    )
    print(f"Log: {log_path}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--foreground",
        action="store_true",
        help="keep the watcher attached to this terminal",
    )
    parser.add_argument(
        "--clear",
        action="store_true",
        help="stop all active notification watchers",
    )
    parser.add_argument("--status", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--watch", type=int, help=argparse.SUPPRESS)
    parser.add_argument("--chat-name", help=argparse.SUPPRESS)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.status:
            print(watcher_status())
            return 0

        if args.clear:
            count = clear_watchers()
            noun = "watcher" if count == 1 else "watchers"
            print(f"Cleared {count} Telegram notification {noun}.")
            return 0

        require_command("notify-send")
        api_id, api_hash = credentials()

        if args.watch is not None:
            if not args.chat_name:
                raise RuntimeError("Internal watcher is missing its chat name.")
            asyncio.run(watch_chat(args.watch, args.chat_name, api_id, api_hash))
            return 0

        require_command("fzf")
        selection = asyncio.run(choose_chat(api_id, api_hash))
        if selection is None:
            return 0

        peer_id, chat_name = selection
        if args.foreground:
            if active_watchers():
                raise RuntimeError(
                    "A Telegram watcher is already running; omit --foreground "
                    "to add this chat to it, or use --clear first."
                )
            print(f"Watching {chat_name} for one message; press Ctrl-C to stop.")
            asyncio.run(watch_chat(peer_id, chat_name, api_id, api_hash))
        else:
            start_background_watcher(peer_id, chat_name)
        return 0
    except KeyboardInterrupt:
        return 130
    except Exception as error:
        print(f"{APP_NAME}: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
