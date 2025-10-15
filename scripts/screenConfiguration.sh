xset -dpms
xset s off

SYSTEM_NAME=$(hostname)
echo $SYSTEM_NAME
if [[ $SYSTEM_NAME == "manjaro" ]]; then
    echo "a"
    main=DP2
    second=eDP1
elif [[ $SYSTEM_NAME == "pc" ]]; then
    second=HDMI-1
    main=DP-3
elif [[ $SYSTEM_NAME == "thinkpad" ]]; then
    main=DP-2
    second=eDP1
else
    main=DP2
    second=DP1-3
fi
echo xrandr --output $main --primary --auto --output $second --auto --left-of $main
xrandr --output $main --primary --auto --output $second --auto --left-of $main
