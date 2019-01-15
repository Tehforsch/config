#!/bin/bash
#Get volume of the pulse audio source $id
increase=5

if [[ $1 -eq 0 ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ -- -$increase%
else
    pactl set-sink-volume @DEFAULT_SINK@ +$increase%
fi
