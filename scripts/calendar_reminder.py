#!/usr/bin/env python3
import sys
import subprocess
import datetime
import time
import os
from pathlib import Path

notify_send_path = sys.argv[1]

CALENDAR_DIRS = [
    os.path.expanduser("~/.local/share/dav/calendar/personal"),
    os.path.expanduser("~/.local/share/dav/calendar/work"),
]

REMINDER_INTERVALS = [9999999999999, 3600, 600]
EVENT_PASSED_TRESHOLD = 300

try:
    from icalendar import Calendar
    from dateutil.rrule import rrulestr
    from dateutil import tz
except ImportError:
    print("Missing dependencies. Install: icalendar python-dateutil")
    sys.exit(1)


class Event:
    def __init__(self, dt, title, uid):
        self.datetime = dt
        self.title = title
        self.uid = uid
        self.reminders_sent = []

    def get_cache_key(self):
        return f"{self.uid}_{self.datetime.isoformat()}"

    def send_notification(self, delta, urgency="normal"):
        import math
        minutes = math.ceil(delta.total_seconds() / 60)
        message = f"{self.title} at {self.datetime.time()} (in {minutes} min)"
        subprocess.check_output([notify_send_path, "--expire-time=3600000", f"--urgency={urgency}", message])

    def notify_if_today(self, delta, urgency="normal"):
        today = datetime.datetime.now().date()
        if self.datetime.date() == today:
            self.send_notification(delta, urgency)

    def notify_if_soon(self):
        delta = self.datetime - datetime.datetime.now()
        for (i, reminder_delta) in enumerate(REMINDER_INTERVALS):
            if i not in self.reminders_sent and delta.total_seconds() < reminder_delta and delta.total_seconds() > -EVENT_PASSED_TRESHOLD:
                urgency = "critical" if i == len(REMINDER_INTERVALS) - 1 else "normal"
                self.notify_if_today(delta, urgency)
                self.reminders_sent.append(i)


def to_datetime(dt_value):
    if isinstance(dt_value, datetime.datetime):
        if dt_value.tzinfo is not None:
            return dt_value.astimezone(tz.tzlocal()).replace(tzinfo=None)
        return dt_value
    elif isinstance(dt_value, datetime.date):
        return datetime.datetime.combine(dt_value, datetime.time(6, 0))
    return None


def get_occurrences_for_day(vevent, target_date):
    dtstart = vevent.get("dtstart")
    if not dtstart:
        return []

    start = dtstart.dt
    start_dt = to_datetime(start)
    if start_dt is None:
        return []

    rrule = vevent.get("rrule")
    if not rrule:
        if start_dt.date() == target_date:
            return [start_dt]
        return []

    rrule_str = rrule.to_ical().decode("utf-8")

    if isinstance(start, datetime.datetime):
        dtstart_for_rrule = start
    else:
        dtstart_for_rrule = datetime.datetime.combine(start, datetime.time(6, 0))

    if dtstart_for_rrule.tzinfo is None:
        dtstart_for_rrule = dtstart_for_rrule.replace(tzinfo=tz.tzlocal())

    try:
        rule = rrulestr(rrule_str, dtstart=dtstart_for_rrule)
    except Exception:
        return []

    day_start = datetime.datetime.combine(target_date, datetime.time.min).replace(tzinfo=tz.tzlocal())
    day_end = datetime.datetime.combine(target_date, datetime.time.max).replace(tzinfo=tz.tzlocal())

    occurrences = []
    try:
        for occurrence in rule.between(day_start, day_end, inc=True):
            occurrences.append(to_datetime(occurrence))
    except Exception:
        pass

    return occurrences


def parse_ics_file(filepath, target_date):
    events = []
    try:
        with open(filepath, "rb") as f:
            cal = Calendar.from_ical(f.read())
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return events

    for component in cal.walk():
        if component.name != "VEVENT":
            continue

        title = str(component.get("summary", "No title"))
        uid = str(component.get("uid", filepath))

        for occurrence_dt in get_occurrences_for_day(component, target_date):
            events.append(Event(occurrence_dt, title, uid))

    return events


def get_events():
    today = datetime.datetime.now().date()
    events = []

    for cal_dir in CALENDAR_DIRS:
        if not os.path.exists(cal_dir):
            continue
        for root, dirs, files in os.walk(cal_dir):
            for filename in files:
                if filename.endswith(".ics"):
                    filepath = os.path.join(root, filename)
                    events.extend(parse_ics_file(filepath, today))

    return events


if __name__ == "__main__":
    event_cache = {}
    last_event_refresh = 0
    EVENT_REFRESH_INTERVAL = 300

    while True:
        current_time = time.time()
        if current_time - last_event_refresh > EVENT_REFRESH_INTERVAL:
            new_events = get_events()
            new_cache = {}

            for event in new_events:
                cache_key = event.get_cache_key()
                if cache_key in event_cache:
                    event.reminders_sent = event_cache[cache_key].reminders_sent
                new_cache[cache_key] = event

            event_cache = new_cache
            last_event_refresh = current_time

        for event in event_cache.values():
            event.notify_if_soon()
        time.sleep(5)
