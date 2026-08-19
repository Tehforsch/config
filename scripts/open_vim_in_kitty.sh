#!/usr/bin/env bash

# Font size for the kitty terminal
FONT_SIZE=16

if (( $# == 0 )); then
	project_root="$(git rev-parse --show-toplevel 2>/dev/null || jj root 2>/dev/null)"
	if [[ -n "$project_root" ]]; then
		cd "$project_root" || exit
		kitty --detach -o font_size=$FONT_SIZE nvim -c 'lua Snacks.picker.files()'
		exit
	fi
fi

# Open a new kitty window with nvim
kitty --detach -o font_size=$FONT_SIZE nvim "$@"
