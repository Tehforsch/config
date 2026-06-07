#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
focus_file="$state_dir/focus_mode_until"
now="$(date +%s)"
focus_until=$((now + 2 * 60 * 60))

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Focus mode" "$1" || echo "Focus mode: $1" >&2
    else
        echo "Focus mode: $1" >&2
    fi
}

mkdir -p "$state_dir"
printf "%s\n" "$focus_until" > "$focus_file"

notify "Telegram and Thunderbird are blocked for 2 hours."
