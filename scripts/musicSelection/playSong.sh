#!/bin/bash
if [[ $# -ne 3 ]]; then
    exit 1
fi
path=$(dirname $(realpath $0))
formatString="%track% - %title%"
artist=$1
album=$2
title=$3
echo "Playing:"
echo "$artist"
echo "$album"
echo "$title"
# I don't know that there is a way to jump to a song directly, while still adding the entire album to the queue.
# Therefore we will now hack our way around this by playing the album and then going to the next track exactly as many times as needed
# mpc clear
# mpc findadd album "$album"
# mpc play
# # Find track number
# trackNumber=$(mpc list track album "$album" title "$title")
# for i in $(seq 2 $trackNumber); do
#     mpc next
# done
