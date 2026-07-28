#!/usr/bin/env bash
folder="$(realpath $HOME/.local/share/tmp)/flamegraphs"
mkdir -p "$folder"
cd "$folder"
ps -e | fzf | awk '{print $1; exit}' | xargs perf record --call-graph dwarf --pid
hotspot perf.data 2> /dev/null
