#!/usr/bin/env bash

# Font size for the kitty terminal
FONT_SIZE=16

# Open a new kitty window with nvim
kitty --detach -o font_size=$FONT_SIZE nvim "$@"
