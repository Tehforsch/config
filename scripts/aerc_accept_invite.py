#!/usr/bin/env python3

import hashlib
import os
import subprocess
import sys
import tempfile
from email import policy
from email.parser import BytesParser
from pathlib import Path


ACCOUNT_CALENDARS = {
    "mailbox": "work/Y2FsOi8vMC8zMDkz",
    "posteo": "personal/personal",
    "strato": "personal/personal",
}


def main() -> None:
    account = sys.argv[1] if len(sys.argv) > 1 else ""
    try:
        relative_dir = ACCOUNT_CALENDARS[account]
    except KeyError:
        raise ValueError(f"Unknown aerc account: {account}") from None

    message = BytesParser(policy=policy.default).parsebytes(sys.stdin.buffer.read())
    calendar_parts = [
        part for part in message.walk() if part.get_content_type() == "text/calendar"
    ]
    if not calendar_parts:
        raise ValueError("This message has no text/calendar part")

    invite = calendar_parts[0].get_payload(decode=True)
    if not invite or b"BEGIN:VEVENT" not in invite:
        raise ValueError("The calendar part contains no event")

    uid = next(
        (
            line.removeprefix(b"UID:").rstrip(b"\r")
            for line in invite.split(b"\n")
            if line.startswith(b"UID:")
        ),
        b"",
    )
    if not uid:
        raise ValueError("The calendar event has no UID")

    calendar_dir = (
        Path.home() / ".local/share/dav/calendar" / relative_dir
    )
    calendar_dir.mkdir(parents=True, exist_ok=True)
    destination = calendar_dir / f"{hashlib.sha256(uid).hexdigest()}.ics"

    fd, temporary_name = tempfile.mkstemp(prefix=".aerc-invite.", dir=calendar_dir)
    try:
        with os.fdopen(fd, "wb") as temporary:
            temporary.write(invite)
        os.replace(temporary_name, destination)
    finally:
        try:
            os.unlink(temporary_name)
        except FileNotFoundError:
            pass

if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        subprocess.run(
            ["notify-send", "Could not add calendar invitation", str(error)],
            check=False,
        )
        raise
