#!/bin/bash

quarantinedAlbums=$(cat ~/music/quarantine | shuf)
outputSeparator="\t"
if [[ $# == 1 ]]; then
    numAlbums=$(echo -E "$quarantinedAlbums" | wc -l)
    lineNumber=$(shuf -i 1-$numAlbums -n 1)
else
    lineNumber=$(echo -E "$quarantinedAlbums" | sed "s/^\"\(.*\)\", \"\(.*\)\"/\1$outputSeparator\2/"  | column -o "   " -s "$(printf "\t")" -t | rofi -i -dmenu -no-custom -format "d" -p "Album:")
fi
echo $lineNumber
if [[ "$lineNumber" == "" ]]; then
    exit 0
fi
line=$(echo -E "$quarantinedAlbums" | head -n $lineNumber | tail -n 1)
artist=$(echo "$line" | sed "s/^\"\(.*\)\",.*/\1/")
album=$(echo "$line" | sed "s/.*, \"\(.*\)\"$/\1/")
if [[ $# == 1 ]]; then
    mpc clear
    mpc findadd album "$album" albumartist "$artist"
    mpc play
else
    path=$(dirname $(realpath $0))
    $path/songSelection.sh "$artist" "$album"
fi
