#!/usr/bin/env bash
echo "hi" > ~/foo
STATE_FILE="$HOME/.local/state/.power_button_led_state"
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "off" ]; then
    sudo ectool led power white
    echo "on" > "$STATE_FILE"
else
    sudo ectool led power off
    echo "off" > "$STATE_FILE"
fi
