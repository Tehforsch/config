#!/bin/bash
ps -e | fzf | awk '{print $1; exit}' | xargs flamegraph -o ~/.local/share/tmp/$(date +%Y-%m-%d-%H-%M-%S).svg --open --pid
