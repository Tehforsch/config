#!/bin/bash
separator="\t"
formatString="%artist%$separator%album%"

if [[ $# == 2 ]]; then
    artistAlbums=$(mpc -f "$formatString" find title "$2")
    title="$2"
    outputSeparator="   -   "
    shuffledArtistAlbums=$(echo -E "$artistAlbums" | uniq) # Don't shuffle for this one
else
    if [[ $# == 1 ]]; then
        artistAlbums=$(mpc -f "$formatString" find artist "$1")
        outputSeparator="   -   "
    else
        artistAlbums=$(mpc -f "$formatString" search artist "")
        outputSeparator=""
    fi
    shuffledArtistAlbums=$(echo -E "$artistAlbums" | uniq | shuf)
fi
artistAlbumIndex=$(echo -E "$shuffledArtistAlbums" | column -o "$outputSeparator" -s "$(printf "\t")" -t | rofi -i -dmenu -format "d" -p "Album:")
artistAlbum=$(echo -E "$shuffledArtistAlbums" | head -n $artistAlbumIndex | tail -n 1)
artist=$(echo -E "$artistAlbum" | cut -f 1)
album=$(echo -E "$artistAlbum" | cut -f 2)
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi

path=$(dirname $(realpath $0))
if [[ $# == 2 ]]; then # We just wanted to query for the album for a specific song
    $path/playSong.sh "$artist" "$album" "$title"
else
    $path/songSelection.sh "$artist" "$album"
fi
