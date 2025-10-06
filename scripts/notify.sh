#!/usr/bin/env bash

# Run a command and send a notification when it finishes
# Usage: notify.sh <command> [args...]

if [ $# -eq 0 ]; then
    echo "Usage: notify.sh <command> [args...]"
    exit 1
fi

# Store the command for display
COMMAND="$*"

# Run the command and capture exit code
"$@"
EXIT_CODE=$?

# Determine notification message based on exit code
if [ $EXIT_CODE -eq 0 ]; then
    MESSAGE="✅ Command completed successfully: $COMMAND"
else
    MESSAGE="❌ Command failed (exit code $EXIT_CODE): $COMMAND"
fi

# Send notification with 8 second timeout
notify-send -t 8000 "Command Finished" "$MESSAGE"

# Exit with the same code as the original command
exit $EXIT_CODE