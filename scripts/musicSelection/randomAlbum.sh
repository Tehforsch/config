#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -g|--genre) genre="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ "$genre" == "" ]]; then
    album=$(mpc list album | shuf | head -n 1)
else
    album=$(mpc list album genre "$genre" | shuf | head -n 1)
fi
mpc clear
mpc findadd album "$album"
mpc play
