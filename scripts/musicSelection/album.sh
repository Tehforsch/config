#!/bin/bash
album=$(mpc list album | shuf | rofi -i -dmenu -p "Album:")
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
mpc clear
mpc findadd album "$album"
mpc play
