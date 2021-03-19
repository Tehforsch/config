i3-msg focus right
sleep 0.10;
xdotool key --clearmodifiers ctrl+p
xdotool key --clearmodifiers Return
if [[ $# == 0 ]]; then
    i3-msg focus left
fi
