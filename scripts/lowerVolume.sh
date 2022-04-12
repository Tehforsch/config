#!/bin/bash
while true; do
    pactl set-sink-volume @DEFAULT_SINK@ -1%
    sleep 600
done
