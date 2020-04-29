#!/bin/bash
artist=$(mpc list artist | rofi -i -dmenu -p "Artist:")
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
album=$(mpc list album artist "$artist" | rofi -i -dmenu -p "Album:")
mpc clear
mpc findadd album "$album"
mpc play
