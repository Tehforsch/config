#!/bin/bash
if [[ $# -ne 3 ]]; then
    exit 1
fi
path=$(dirname $(realpath $0))
formatString="%track% - %title%"
artist=$1
album=$2
title=$3
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
if [[ $title == "" ]]; then # Aborted query
   exit 1
fi
echo "Playing:"
echo "$artist"
echo "$album"
echo "$title"
# I don't know that there is a way to jump to a song directly, while still adding the entire album to the queue.
# Therefore we will now hack our way around this by playing the album and then going to the next track exactly as many times as needed
mpc clear
mpc findadd album "$album"
mpc play
discNumber=$(mpc list disc album "$album" title "$title")
trackNumber=$(mpc list track album "$album" title "$title")
# I thought I could implement this with a while loop that queries for the currently playing title with mpc current but then there will be playback of small excerpts of all songs between the first and the one we want which is really annoying so instead we do some math:
math=$(expr $discNumber - 1)
for i in $(seq 1 $(expr $discNumber - 1)); do
    numTracksOnThisAlbum=$(mpc list title disc "$i" album "$album" artist "$artist" | wc -l)
    for i in $(seq 1 $numTracksOnThisAlbum); do
        mpc next
        echo "Skip"
    done
done
# We are now on the correct disc.
for i in $(seq 2 $trackNumber); do
    mpc next
    echo "Skip2"
done
