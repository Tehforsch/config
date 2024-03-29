#!/bin/bash
while true; do
    soundPlaying=$(pactl list | grep -c "RUNNING") 
    pacmanRunning=$(pgrep pacman | wc -l) 
    scpRunning=$(pgrep scp | wc -l) 
    reaperRunning=$(pgrep -x reaper | wc -l)
    echo $soundPlaying $pacmanRunning $scpRunning $reaperRunning
    if [[ $soundPlaying -ge 1 || "$pacmanRunning" -ge 1 || "$scpRunning" -ge 1 || "$reaperRunning" -ge 1 ]]; then
        echo disabled
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    else
        echo enabled
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false
    fi
    sleep 60
done
