xset -dpms
xset s off

SYSTEM_NAME=$(hostname)
echo $SYSTEM_NAME
if [[ $SYSTEM_NAME == "manjaro" ]]; then
    echo "a"
    main=DP2
    second=eDP1
elif [[ $SYSTEM_NAME == "pc" ]]; then
    second=DVI-D-0
    main=HDMI-0
elif [[ $SYSTEM_NAME == "thinkpad" ]]; then
    main=DP-2
    second=eDP1
else
    main=DP2
    second=DP1-3
fi
echo xrandr --output $main --primary --auto --output $second --auto --right-of $main
xrandr --output $main --primary --auto --output $second --auto --right-of $main
