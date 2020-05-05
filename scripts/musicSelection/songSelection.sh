#!/bin/bash
# Select song from a specific album and a specific artist. This is always called
# after any album selection
if [[ $# -ne 2 ]]; then
    exit 1
fi
formatString="%title%"
artist=$1
album=$2
titles=$(mpc -f "$formatString" find album "$album" artist "$artist")
title=$(echo "$titles" | rofi -i -dmenu -no-custom -p "Choose a song:")
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/playSong.sh "$artist" "$album" "$title"
