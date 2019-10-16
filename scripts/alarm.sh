#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Need one argument: The time at which to wake up."
else
    nowInSeconds=$(date +%s)
    thenInSeconds=$(date +%s -d $1)
    diffInSeconds=$((thenInSeconds - nowInSeconds))
    secondsPerDay=$((3600 * 24))
    if [[ $diffInSeconds -lt 0 ]]; then
        diffInSeconds=$((diffInSeconds + secondsPerDay))
    fi
    hours=$((diffInSeconds / 3600))
    remainingDiff=$((diffInSeconds - hours * 3600))
    minutes=$((remainingDiff / 60))
    echo "Waking up in $hours hours and $minutes minutes"
    sudo rtcwake -u -s $diffInSeconds -m mem
fi
