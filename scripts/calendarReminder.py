import sys
import subprocess
import datetime
import time

khal_path = sys.argv[1]
notify_send_path = sys.argv[2]
vdirsyncer_path = sys.argv[3]

REMINDER_INTERVALS = [9999999999999, 3600, 600]

class Event:
    def __init__(self, datetime, title):
        self.datetime = datetime
        self.title = title
        self.reminders_sent = []

    def send_notification(self):
        message = f"{self.datetime.time()}: {self.title}"
        subprocess.check_output([notify_send_path, "--urgency=critical", "--expire-time=3600000", message])

    def notify_if_today(self):
        today = datetime.datetime.now().date()
        if self.datetime.date() == today:
            self.send_notification()

    def notify_if_soon(self):
        delta = self.datetime - datetime.datetime.now()
        for (i, reminder_delta) in enumerate(REMINDER_INTERVALS):
            if i not in self.reminders_sent and delta.total_seconds() < reminder_delta:
                self.notify_if_today()
                self.reminders_sent.append(i)


def get_event(line):
    date, *title = line.split(" ")
    title = " ".join(title)
    year, month, day, rest = date.split("-")
    try:
        hour, minute = rest.split(":")
    except ValueError:
        # all day event, pick a random time
        hour, minute = (6, 0)
    date = datetime.datetime(year=int(year), month=int(month), day=int(day), hour=int(hour), minute=int(minute))
    return Event(date, title)

def get_events():
    # As of writing this, --json didnt work for my version of khal,
    # so I will be doing some messy stuff.
    cmd = khal_path + " list --day-format \"\" --format \"{start-date}-{start-time} {title}\""
    print(cmd)
    result = subprocess.check_output(cmd, shell=True).decode(sys.stdout.encoding)
    return [get_event(line) for line in result.split("\n") if line.strip() != ""]

if __name__ == "__main__":
    events = get_events()
    time.sleep(5)
    while True:
        try:
            subprocess.check_output([vdirsyncer_path, "discover"])
            subprocess.check_output([vdirsyncer_path, "sync"])
        except CalledProcessError as e:
            print(e)
            time.sleep(1)
            continue
        finally:
            break
    while True:
        for event in events:
            event.notify_if_soon()
        time.sleep(5)
    
