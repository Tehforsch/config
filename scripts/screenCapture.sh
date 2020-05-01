#!/bin/bash
if [[ $# == 0 ]]; then
    mkdir -p ~/.screenCaptures
    outputFile=~/.screenCaptures/$(date +%Y-%m-%d-%H-%M-%S).mkv
    ffmpeg -f x11grab -video_size 1920x1080 -framerate 30 -i :0.0 -f pulse -i default -preset ultrafast -crf 18 -pix_fmt yuv420p $outputFile
else
    killall ffmpeg
fi
