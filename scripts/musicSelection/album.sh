#!/bin/bash
separator="\t"
formatString="%albumartist%$separator%album%"

if [[ $# == 1 ]]; then
    artistAlbums=$(mpc -f "$formatString" find albumartist "$1")
    outputSeparator="   -   "
else
    artistAlbums=$(mpc -f "$formatString" search artist "")
    outputSeparator=""
fi
shuffledArtistAlbums=$(echo -E "$artistAlbums" | uniq | shuf)
artistAlbumIndex=$(echo -E "$shuffledArtistAlbums" | column -o "$outputSeparator" -s "$(printf "\t")" -t | rofi -i -dmenu -no-custom -format "d" -p "Album:")
artistAlbum=$(echo -E "$shuffledArtistAlbums" | head -n $artistAlbumIndex | tail -n 1)
artist=$(echo -E "$artistAlbum" | cut -f 1)
album=$(echo -E "$artistAlbum" | cut -f 2)
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/songSelection.sh "$artist" "$album"
