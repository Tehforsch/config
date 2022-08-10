#!/bin/bash
while true; do
    soundPlaying=$(pacmd list-sink-inputs | grep -c "RUNNING") 
    criticalProgramsRunning=$(pgrep pacman | wc -l) 
    # Since i am too dumb to use "or" in bash and bash just sucks, here we go:
    if [[ $soundPlaying -ge 1 ]]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    elif [[ $criticalProgramsRunning -ge 1 ]]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    else
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false
    fi
    sleep 60
done
