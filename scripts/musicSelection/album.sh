#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -g|--genre) genre="$2"; shift ;;
        -a|--artist) artist="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

separator="\t"
formatString="%albumartist%$separator%album%"

if [ "$artist" != "" ]; then
    if [ "$genre" != "" ]; then
        artistAlbums=$(mpc -f "$formatString" find albumartist "$artist" genre "$genre")
    else
        artistAlbums=$(mpc -f "$formatString" find albumartist "$artist")
    fi
    outputSeparator="   -   "
else
    if [ "$genre" != "" ]; then
        artistAlbums=$(mpc -f "$formatString" find genre "$genre")
        outputSeparator="   -   "
    else
        artistAlbums=$(mpc -f "$formatString" search albumartist "")
        outputSeparator=""
    fi
fi
shuffledArtistAlbums=$(echo -E "$artistAlbums" | uniq | shuf)
artistAlbumIndex=$(echo -E "$shuffledArtistAlbums" | column -o "$outputSeparator" -s "$(printf "\t")" -t | rofi -i -dmenu -no-custom -format "d" -kb-custom-1 "Ctrl+Return" -p "Album:")
exitCode=$?
artistAlbum=$(echo -E "$shuffledArtistAlbums" | head -n $artistAlbumIndex | tail -n 1)
artist=$(echo -E "$artistAlbum" | cut -f 1)
album=$(echo -E "$artistAlbum" | cut -f 2)
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
echo $exitCode

if [ "$exitCode" == "10" ]; then
    mpc findadd album "$album" artist "$artist" # Queue album
else
    path=$(dirname $(realpath $0))
    $path/songSelection.sh "$artist" "$album"
fi
