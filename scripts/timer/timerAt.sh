#!/bin/bash

time2=$1

if [[ $# == 1 ]]; then
    sec1=$(date +%s)
    sec2=$(date +%s -d $time2)

    diff=$((sec2 - sec1))
    remainTime=300
    timerDir="$( cd "$(dirname "$0")" ; pwd -P )"
    for i in $(seq 1 $diff); do
        sleep 1
    done
    aplay $timerDir/beep.wav
    sleep 1
    aplay $timerDir/beep.wav
    sleep 1
    aplay $timerDir/beep.wav
    sleep 1
    sleep $remainTime
fi

