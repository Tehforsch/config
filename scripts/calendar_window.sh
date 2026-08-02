#!/usr/bin/env bash
set -euo pipefail

if i3-msg -t get_tree | jq -e '.. | objects | select(.window_properties?.class == "calendar")' >/dev/null; then
    i3-msg '[class="^calendar$"] move workspace current' >/dev/null
    i3-msg '[class="^calendar$"] focus' >/dev/null
    exit 0
fi

exec kitty --class=calendar --title="calendar" -o font_size=16 calendar
