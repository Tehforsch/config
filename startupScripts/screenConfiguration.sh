#!/bin/bash
xset -dpms
xset s off

source ~/.localConfig
if [[ $systemName == "ubuntu" ]]; then
    echo "a"
    main=HDMI1
    second=eDP1
    xrandr --output $main --primary --auto --output $second --auto --left-of $main
else
    echo "b"
    main=DP-2
    left=eDP-1
    right=DP-1-3
    xrandr --output $main --primary --auto --output $left --auto --left-of $main --output $right --auto --right-of $main --rotate left
fi
