#!/bin/bash
# Select song from a specific album and a specific artist. This is always called
# after any album selection
if [[ $# -ne 2 ]]; then
    exit 1
fi
path=$(dirname $(realpath $0))
formatString="%track% - %title%"
artist=$1
album=$2
titles=$(mpc -f "$formatString" find album "$album" artist "$artist")
title=$(echo "$titles" | rofi -i -dmenu -p "Choose a song:")
if [[ $(echo "$album" | wc -l) != 1 ]]; then
    album=$(echo "$album" | rofi -i -dmenu -p "Many albums available, select one:")
fi
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
$path/playSong.sh "$artist" "$album" "$title"
