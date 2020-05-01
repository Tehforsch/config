#!/bin/bash
title=$(mpc list title | shuf | rofi -i -dmenu -p "Song title:")
echo $title
album=$(mpc list album title "$title")
if [[ $(echo "$album" | wc -l) != 1 ]]; then
    album=$(echo "$album" | rofi -i -dmenu -p "Many albums available, select one:")
fi
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
# I don't know that there is a way to jump to a song directly, while still adding the entire album to the queue.
# Therefore we will now hack our way around this by playing the album and then going to the next track exactly as many times as needed
mpc clear
mpc findadd album "$album"
mpc play
# Find track number
echo "Found album: $album"
trackNumber=$(mpc list track album "$album" title "$title")
echo "Found track number: $trackNumber"
for i in $(seq 2 $trackNumber); do
    mpc next
done
