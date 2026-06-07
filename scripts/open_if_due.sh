#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <program-name> <hours> <command> [args...]" >&2
    exit 2
fi

program_name="$1"
hours="$2"
shift 2

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/last_open"
state_file="$state_dir/$program_name"
now="$(date +%s)"
limit_seconds=$((hours * 60 * 60))

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$program_name" "$1" || echo "$program_name: $1" >&2
    else
        echo "$program_name: $1" >&2
    fi
}

format_elapsed() {
    local elapsed="$1"
    local elapsed_hours=$((elapsed / 3600))
    local elapsed_minutes=$(((elapsed % 3600) / 60))

    if ((elapsed_hours > 0)); then
        if ((elapsed_minutes > 0)); then
            printf "%d hours and %d minutes" "$elapsed_hours" "$elapsed_minutes"
        else
            printf "%d hours" "$elapsed_hours"
        fi
    else
        printf "%d minutes" "$elapsed_minutes"
    fi
}

if [[ -r "$state_file" ]]; then
    last_opened="$(<"$state_file")"
    if [[ "$last_opened" =~ ^[0-9]+$ ]]; then
        elapsed=$((now - last_opened))
        if ((elapsed >= 0 && elapsed < limit_seconds)); then
            elapsed_text="$(format_elapsed "$elapsed")"
            notify "It's only been $elapsed_text since $program_name was opened."
            exit 0
        fi
    fi
fi

mkdir -p "$state_dir"
printf "%s\n" "$now" > "$state_file"

exec "$@"
