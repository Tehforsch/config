#!/usr/bin/env bash
api_key=$(cat ~/resource/keys/torga/api_key)
# Temporary fix while we're installing from cargo
export PATH=$PATH:~/.cargo/bin
torga-cli --data-path ~/.local/share/todo --config ~/.config/todo/torga.yml --api-key $api_key tui
