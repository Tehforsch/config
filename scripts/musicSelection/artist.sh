#!/bin/bash
artist=$(mpc list albumartist | shuf | rofi -i -dmenu -no-custom -p "Artist:")
echo $artist
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/album.sh "$artist"
