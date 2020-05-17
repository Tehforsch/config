#!/bin/bash
separator="\t"
formatString="%albumartist%$separator%album%$separator%title%"
list=$(mpc -f "$formatString" search albumartist "")
outputSeparator=" "
shuffled=$(echo -E "$list" | uniq | shuf)
index=$(echo -E "$shuffled" | column -o "$outputSeparator" -s "$(printf "\t")" -t -T 1,2,3 --output-width 200  | rofi -i -dmenu -no-custom -format "d" -p "Song:" -width 1920)
artistAlbumTitle=$(echo -E "$shuffled" | head -n $index | tail -n 1)
artist=$(echo -E "$artistAlbumTitle" | cut -f 1)
album=$(echo -E "$artistAlbumTitle" | cut -f 2)
title=$(echo -E "$artistAlbumTitle" | cut -f 3)
path=$(dirname $(realpath $0))
$path/playSong.sh "$artist" "$album" "$title"
