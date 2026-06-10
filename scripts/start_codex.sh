#!/usr/bin/env bash
set -euo pipefail

day_of_week="$(date +%u)"

case "$day_of_week" in
    2|4)
        echo "Not starting codex on Tuesday or Thursday."
        exit 0
        ;;
esac

exec codex -c 'tui.notifications=false' "$@"
