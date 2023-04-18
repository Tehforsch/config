#!/bin/bash
folder="$(realpath $HOME/.local/share/tmp)/flamegraphs"
mkdir -p "$folder"
cd "$folder"
ps -e | fzf | awk '{print $1; exit}' | xargs flamegraph -o "$folder/$(date +%Y-%m-%d-%H-%M-%S).svg" --open --pid
