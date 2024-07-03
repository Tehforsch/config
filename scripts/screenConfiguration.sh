#!/bin/zsh
xset -dpms
xset s off

SYSTEM_NAME=$(hostname)
echo $SYSTEM_NAME
if [[ $SYSTEM_NAME == "manjaro" ]]; then
    echo "a"
    main=DP2
    second=eDP1
elif [[ $SYSTEM_NAME == "pc" ]]; then
    main=HDMI-0
    second=DP-1
elif [[ $SYSTEM_NAME == "ita" ]]; then
    # try both because this is ridiculously inconsistent
    main=DP2
    second=eDP1
    xrandr --output $main --primary --auto --output $second --auto --left-of $main
    main=DP-2
    second=eDP-1
else
    main=DP2
    second=DP1-3
fi
xrandr --output $main --primary --auto --output $second --auto --left-of $main
