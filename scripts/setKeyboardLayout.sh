#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <layout_name>"
    echo "Available layouts: custom, passthrough"
    exit 1
fi

config=/home/toni/projects/config
layout="$1"

case "$layout" in
    "custom")
        setxkbmap -layout de -variant nodeadkeys -option caps:escape
        xmodmap $config/xmodmap/xmodmapNormal
        ;;
    "passthrough")
        setxkbmap -layout de -variant nodeadkeys
        xmodmap $config/xmodmap/xmodmapPassthrough
        ;;
    *)
        echo "Unknown layout: $layout"
        echo "Available layouts: custom, passthrough"
        exit 1
        ;;
esac