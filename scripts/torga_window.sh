#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if i3-msg -t get_tree | jq -e '.. | objects | select(.window_properties?.class == "torga")' >/dev/null; then
    i3-msg '[class="^torga$"] move workspace current' >/dev/null
    i3-msg '[class="^torga$"] focus' >/dev/null
    exit 0
fi

exec kitty --class=torga --title="torga/todo" -o font_size=16 bash "$script_dir/run_torga.sh"
