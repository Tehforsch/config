#!/bin/bash
xset -dpms
xset s off

systemName=$(cat ~/.systemName)
if [[ $systemName == "manjaro" ]]; then
    echo "a"
    main=HDMI1
    second=eDP1
    xrandr --output $main --primary --auto --output $second --auto --left-of $main
else
    xrandr --output HDMI-0 --primary
fi
