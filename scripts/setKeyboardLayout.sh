#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <layout_name>"
    echo "Available layouts: custom, passthrough"
    exit 1
fi

layout="$1"
swaymsg input type:keyboard xkb_layout "$layout"