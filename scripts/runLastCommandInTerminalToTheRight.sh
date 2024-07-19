xdotool key --clearmodifiers F9
xdotool key --clearmodifiers l
xdotool key --clearmodifiers Escape
sleep 0.08;
xdotool key --clearmodifiers ctrl+p
xdotool key --clearmodifiers Return
if [[ $# == 0 ]]; then
    xdotool key F9
    sleep 0.1
    xdotool key h
    sleep 0.1
    xdotool key Tab
fi
