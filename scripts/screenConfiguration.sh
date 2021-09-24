#!/bin/bash
xset -dpms
xset s off

systemName=$(cat ~/.systemName)
if [[ $systemName == "manjaro" ]]; then
    echo "a"
    main=DP2
    second=eDP1
elif [[ $systemName == "manjaroPc" ]]; then
    main=DP-0
    second=DP2
elif [[ $systemName == "ita" ]]; then
    main=DP2
    second=eDP1
else
    main=DP2
    second=DP1-3
fi
xrandr --output $main --primary --auto --output $second --auto --left-of $main
