xrandr --output HDMI1 --auto --output eDP1 --auto --left-of HDMI1
# xrandr --output DP1 --auto --output eDP1 --auto --left-of DP1
xrandr --output HDMI1 --auto --output eDP1 --auto --left-of HDMI1
xset -dpms
xset s off
#!/bin/bash
#Get volume of the pulse audio source $id
increase=4

if [[ $(lsb_release -a | grep 18.04 | wc -l) == 2 ]]; then
    main=HDMI1
    second=eDP1
else
    main=FILLTHISIN
    second=eDP-1
fi
xrandr --output $main --primary --auto --output $second --auto --left-of $main
