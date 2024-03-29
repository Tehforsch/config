#!/bin/zsh
xset -dpms
xset s off

SYSTEM_NAME=$(cat ~/.config/systemName/name)
echo $SYSTEM_NAME
if [[ $SYSTEM_NAME == "manjaro" ]]; then
    echo "a"
    main=DP2
    second=eDP1
elif [[ $SYSTEM_NAME == "manjaroPc" ]]; then
    main=DP-0
    second=DP2
    if [[ $1 == "" ]]; then
        xrandr --output HDMI-0 --primary --auto --output DVI-D-0 --auto --right-of HDMI-0
    else
        xrandr --output HDMI-0 --primary --auto --output DVI-D-0 --off
    fi
    exit 0
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
