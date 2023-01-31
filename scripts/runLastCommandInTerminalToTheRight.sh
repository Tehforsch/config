xdotool key --clearmodifiers F9
xdotool key --clearmodifiers l
xdotool key --clearmodifiers Return
sleep 0.01;
xdotool key --clearmodifiers ctrl+p
xdotool key --clearmodifiers Return
if [[ $# == 0 ]]; then
    xdotool key --clearmodifiers F9
    xdotool key --clearmodifiers h
    xdotool key --clearmodifiers Return
fi
