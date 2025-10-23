import sys
import subprocess
import datetime
import time
import json

khal_path = sys.argv[1]
notify_send_path = sys.argv[2]

REMINDER_INTERVALS = [9999999999999, 3600, 600]
EVENT_PASSED_TRESHOLD = 300

class Event:
    def __init__(self, datetime, title, uid):
        self.datetime = datetime
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
                # Use critical urgency for the last (smallest) interval, normal for others
                urgency = "critical" if i == len(REMINDER_INTERVALS) - 1 else "normal"
                self.notify_if_today(delta, urgency)
                self.reminders_sent.append(i)


def get_events():
    cmd = [khal_path, "list", "--json", "title", "--json", "start-date-long-full", "--json", "start-time-full", "--json", "uid"]
    print(" ".join(cmd))
    result = subprocess.check_output(cmd).decode(sys.stdout.encoding)
    events = []
    # Parse multiple JSON arrays (one per day)
    for line in result.strip().split('\n'):
        if line.strip():
            events_data = json.loads(line)
            for event_data in events_data:
                title = event_data["title"]
                date_str = event_data["start-date-long-full"]
                time_str = event_data.get("start-time-full", "06:00")
                uid = event_data["uid"]
                
                # Combine date and time
                datetime_str = f"{date_str} {time_str}"
                try:
                    event_datetime = datetime.datetime.strptime(datetime_str, "%Y-%m-%d %H:%M")
                except ValueError:
                    # Fallback for all-day events
                    event_datetime = datetime.datetime.strptime(date_str + " 06:00", "%Y-%m-%d %H:%M")
                events.append(Event(event_datetime, title, uid))
    return events

if __name__ == "__main__":
    event_cache = {}  # Cache keyed by uid_datetime
    last_event_refresh = 0
    EVENT_REFRESH_INTERVAL = 300  # Refresh events every 5 minutes
    
    while True:
        current_time = time.time()
        if current_time - last_event_refresh > EVENT_REFRESH_INTERVAL:
            new_events = get_events()
            new_cache = {}
            
            # Preserve reminders_sent state for existing events
            for event in new_events:
                cache_key = event.get_cache_key()
                if cache_key in event_cache:
                    # Preserve the reminders_sent state
                    event.reminders_sent = event_cache[cache_key].reminders_sent
                new_cache[cache_key] = event
            
            event_cache = new_cache
            last_event_refresh = current_time
        
        for event in event_cache.values():
            event.notify_if_soon()
        time.sleep(5)
    
