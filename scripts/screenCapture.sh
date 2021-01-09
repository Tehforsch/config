#!/bin/bash
sleep 0.1
if [[ $# == 0 ]]; then
    geom=$(xrectsel)
    echo "$geom" >> ~/.playground/sc
    pat='([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)'
    [[ "$geom" =~ $pat ]]
    xSize="${BASH_REMATCH[1]}"
    ySize="${BASH_REMATCH[2]}"
    xOff="${BASH_REMATCH[3]}"
    yOff="${BASH_REMATCH[4]}"
    # Make the sizes even which is needed for ffmpeg
    if [[ $(($xSize % 2)) == 1 ]]; then
        xSize=$(($xSize + 1))
    fi
    if [[ $(($ySize % 2)) == 1 ]]; then
        ySize=$(($ySize + 1))
    fi
    mkdir -p ~/.screenCaptures
    outputFile=~/.screenCaptures/$(date +%Y-%m-%d-%H-%M-%S).mkv
    ffmpeg -f x11grab -video_size ${xSize}x${ySize} -framerate 30 -i :0.0+${xOff},${yOff} -preset ultrafast -crf 18 -pix_fmt yuv420p $outputFile
else
    killall ffmpeg
fi
