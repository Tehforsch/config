#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

time2=$1

if [[ $# == 1 ]]; then
    sec1=$(date +%s)
    sec2=$(date +%s -d $time2)

    diff=$((sec2 - sec1))
    # Can't call timer.sh here because that messes up the ps output for some reason
    remainTime=300
    timerDir="$( cd "$(dirname "$0")" ; pwd -P )"
    for i in $(seq 1 $diff); do
        sleep 1
    done
    paplay $timerDir/beep.wav
    sleep 1
    paplay $timerDir/beep.wav
    sleep 1
    paplay $timerDir/beep.wav
    sleep 1
    sleep $remainTime
fi

