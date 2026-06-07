#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
focus_file="$state_dir/focus_mode_until"

if [[ ! -r "$focus_file" ]]; then
    printf '{"text":""}\n'
    exit 0
fi

now="$(date +%s)"
focus_until="$(<"$focus_file")"

if [[ ! "$focus_until" =~ ^[0-9]+$ || "$now" -ge "$focus_until" ]]; then
    rm -f "$focus_file"
    printf '{"text":""}\n'
    exit 0
fi

remaining=$((focus_until - now))
hours=$((remaining / 3600))
minutes=$(((remaining % 3600) / 60))

printf '{"state":"Warning","text":"FOCUS %dh %02dm"}\n' "$hours" "$minutes"
