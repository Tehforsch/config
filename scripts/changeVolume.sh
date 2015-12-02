#!/bin/bash
#Get volume of the pulse audio source $id
for id in $(seq 0 5)
do
    increase=5

    if [[ $1 -eq 0 ]]; then
        pactl set-sink-volume $id -- -$increase%
    else
        line=$(expr 1 + $id + $id)
        volume=$(pactl list | ~/.bin/ack Volume | head -n $line | tail -n 1 | ~/.bin/ack "Volume: 0:[\s]* ([\d]*)%" --output=\$1)
        echo "Current volume : $volume"
        #If volume is > 100-increase (that means no overdrive going on if we increase by increase%) then increase the volume
        maxVolume=100
        maxVolume=$(expr $maxVolume - $increase)
        if [[ "$volume" -le "$maxVolume" ]]; then
            echo $volume"hi"
            pactl set-sink-volume $id -- +$increase%
            echo "pactl set-sink-volume $id -- +$increase%"
        else
            echo $volume"ho"
            increase=$(expr 100 - $volume)
        fi
    fi
done
