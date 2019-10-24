#!/bin/bash
xset -dpms
xset s off

source ~/.localConfig
if [[ $systemName == "ubuntu" ]]; then
    echo "a"
    main=HDMI1
    second=eDP1
else
    echo "b"
    main=DP-1-3
    second=eDP-1
fi
xrandr --output $main --primary --auto --output $second --auto --left-of $main
