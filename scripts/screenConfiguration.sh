xset -dpms
xset s off

SYSTEM_NAME=$(hostname)
echo $SYSTEM_NAME

orientation=right-of
if [[ $SYSTEM_NAME == "framework" ]]; then
    main=DP-2
    second=eDP-1
    orientation=left-of
elif [[ $SYSTEM_NAME == "pc" ]]; then
    second=DVI-D-0
    main=HDMI-0
    orientation=left-of
elif [[ $SYSTEM_NAME == "thinkpad" ]]; then
    main=DP-2
    second=eDP1
else
    main=DP2
    second=DP1-3
fi
echo xrandr --output $main --primary --auto --output $second --auto --$orientation $main
xrandr --output $main --primary --auto --output $second --auto --$orientation $main
