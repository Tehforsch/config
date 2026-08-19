#!/usr/bin/env python3
"""Print upcoming calendar events in a compact i3status-rust format."""

import datetime as dt
import os
import sys
from pathlib import Path

from dateutil import tz
from dateutil.rrule import rrulestr
from icalendar import Calendar


CALENDAR_DIRS = (
    Path(os.path.expanduser("~/.local/share/dav/calendar/personal")),
    Path(os.path.expanduser("~/.local/share/dav/calendar/work")),
)
LOOKAHEAD = dt.timedelta(hours=1)
MAX_TITLE_LENGTH = 20
HIDDEN_TITLE_SUBSTRINGS = ("es muss halt immer",)
TITLE_ALIASES = {"Scanner Daily": "Daily"}
STATE_DIR = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
HIDDEN_UNTIL_FILE = STATE_DIR / "calendar_status_hidden_date"


def hide_today():
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    HIDDEN_UNTIL_FILE.write_text(dt.date.today().isoformat())


def hidden_today():
    try:
        return HIDDEN_UNTIL_FILE.read_text().strip() == dt.date.today().isoformat()
    except OSError:
        return False


def property_values(component, name):
    value = component.get(name)
    if value is None:
        return []
    return value if isinstance(value, list) else [value]


def local_datetime(value):
    """Return an aware local datetime, or None for all-day events."""
    if not isinstance(value, dt.datetime):
        return None
    if value.tzinfo is None:
        return value.replace(tzinfo=tz.tzlocal())
    return value.astimezone(tz.tzlocal())


def excluded_datetimes(component):
    excluded = set()
    for field in property_values(component, "exdate"):
        for value in field.dts:
            converted = local_datetime(value.dt)
            if converted is not None:
                excluded.add(converted)
    return excluded


def starts_between(component, window_start, window_end):
    start_field = component.get("dtstart")
    if start_field is None:
        return []

    first_start = local_datetime(start_field.dt)
    if first_start is None:
        return []

    recurrence = component.get("rrule")
    if recurrence is None:
        starts = [first_start]
    else:
        try:
            rule = rrulestr(
                recurrence.to_ical().decode("utf-8"), dtstart=first_start
            )
            starts = rule.between(window_start, window_end, inc=True)
        except (TypeError, ValueError, OverflowError):
            starts = []

    for field in property_values(component, "rdate"):
        starts.extend(
            converted
            for value in field.dts
            if (converted := local_datetime(value.dt)) is not None
        )

    excluded = excluded_datetimes(component)
    return [
        start
        for start in starts
        if window_start <= start <= window_end and start not in excluded
    ]


def upcoming_events(now):
    events = {}
    window_end = now + LOOKAHEAD

    for calendar_dir in CALENDAR_DIRS:
        if not calendar_dir.exists():
            continue
        for filepath in calendar_dir.rglob("*.ics"):
            try:
                calendar = Calendar.from_ical(filepath.read_bytes())
            except (OSError, ValueError):
                continue

            for component in calendar.walk("VEVENT"):
                if str(component.get("status", "")).upper() == "CANCELLED":
                    continue
                title = str(component.get("summary", "Untitled"))
                if any(
                    hidden in title.casefold() for hidden in HIDDEN_TITLE_SUBSTRINGS
                ):
                    continue
                uid = str(component.get("uid", filepath))
                for start in starts_between(component, now, window_end):
                    events[(uid, start)] = (start, title)

    return sorted(events.values())


def compact_title(title):
    title = TITLE_ALIASES.get(title, title)
    title = " ".join(title.split())
    if len(title) <= MAX_TITLE_LENGTH:
        return title
    return title[: MAX_TITLE_LENGTH - 1].rstrip() + "…"


def countdown(delta):
    total_minutes = max(0, int(delta.total_seconds() // 60))
    hours, minutes = divmod(total_minutes, 60)
    if hours and minutes:
        return f"{hours}h{minutes:02}m"
    if hours:
        return f"{hours}h"
    return f"{minutes}m"


def main():
    if sys.argv[1:] == ["--hide-today"]:
        hide_today()
        return
    if sys.argv[1:]:
        raise SystemExit(f"Usage: {Path(sys.argv[0]).name} [--hide-today]")
    if hidden_today():
        print()
        return

    now = dt.datetime.now(tz.tzlocal())
    entries = [
        f"{compact_title(title)} {countdown(start - now)}"
        for start, title in upcoming_events(now)
    ]
    print("  ·  ".join(entries))


if __name__ == "__main__":
    main()
