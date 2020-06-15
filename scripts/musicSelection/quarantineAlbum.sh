#!/bin/bash
quarantinedAlbums=$(cat ~/music/quarantine)
outputSeparator="\t"
lineNumber=$(echo -E "$quarantinedAlbums" | sed "s/^\"\(.*\)\", \"\(.*\)\"/\1$outputSeparator\2/"  | column -o "   " -s "$(printf "\t")" -t | shuf | rofi -i -dmenu -no-custom -format "d" -p "Album:")
if [[ "$lineNumber" == "" ]]; then
    exit 0
fi
line=$(echo -E "$quarantinedAlbums" | head -n $lineNumber | tail -n 1)
# line2=$(echo "$line" | grep -o "\"(.*)\", \"(.*)\"")
artist=$(echo "$line" | sed "s/^\"\(.*\)\",.*/\1/")
album=$(echo "$line" | sed "s/.*, \"\(.*\)\"$/\1/")
echo $artist
echo $album
