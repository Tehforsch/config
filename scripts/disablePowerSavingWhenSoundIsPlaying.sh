#!/bin/bash
while true; do
    soundPlaying=$(pacmd list-sink-inputs | grep -c "RUNNING") 
    criticalProgramsRunning=$(pgrep pacman | wc -l) 
    if [[ $soundPlaying -ge 1 || "$critcalProgramsRunning" -ge 1 ]]; then
        echo disabled
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    else
        echo enabled
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false
    fi
    sleep 60
done
