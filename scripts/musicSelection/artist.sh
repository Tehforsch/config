#!/bin/bash
artist=$(mpc list artist | shuf | rofi -i -dmenu -p "Artist:")
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/album.sh "$artist"
