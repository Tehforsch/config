#!/usr/bin/env bash

# Get the focused window's class
focused_class=$(i3-msg -t get_tree | jq -r '.. | select(.focused? == true) | .window_properties.class')

# Check if the focused window is one of the target classes
if [[ "$focused_class" == "Mattermost" || "$focused_class" == "KeePassXC" ]]; then
    i3-msg move scratchpad
fi