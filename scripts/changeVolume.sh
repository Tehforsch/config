#!/bin/bash
#Get volume of the pulse audio source $id
increase=4

if [[ $(lsb_release -a | grep 18.04 | wc -l) == 2 ]]; then
    if [[ $1 -eq 0 ]]; then
        pactl set-sink-volume @DEFAULT_SINK@ -$increase%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$increase%
    fi
else
    if [[ $1 -eq 0 ]]; then
        pactl set-sink-volume @DEFAULT_SINK@ -- -$increase%
    else
        pactl set-sink-volume @DEFAULT_SINK@ -- +$increase%
    fi
fi
