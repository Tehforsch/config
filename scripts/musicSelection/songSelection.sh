#!/bin/bash
# Select song from a specific album and a specific artist. This is always called
# after any album selection
if [ $1 == "--preselect" ]; then
    songIndex=$2
    shift; shift
else
    songIndex=0
fi

if [[ $# -ne 2 ]]; then
    exit 1
fi
formatString="%title%"
artist=$1
album=$2
titles=$(mpc -f "$formatString" find album "$album" albumartist "$artist")
title=$(echo "$titles" | rofi -i -dmenu -no-custom -p "Choose a song:" -selected-row $songIndex)
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/playSong.sh "$artist" "$album" "$title"
