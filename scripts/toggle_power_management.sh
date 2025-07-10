#!/bin/bash

# Toggle power management by creating/removing keep_on file
keep_on_file="/home/toni/.local/state/keep_on"

if [ -f "$keep_on_file" ]; then
    rm "$keep_on_file"
    echo "Power management enabled (keep_on file removed)"
else
    mkdir -p "$(dirname "$keep_on_file")"
    touch "$keep_on_file"
    echo "Power management disabled (keep_on file created)"
fi