#!/usr/bin/env bash
set -euo pipefail

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/keep_on"

if [[ -e "$state_file" ]]; then
    printf '{"state":"Good","text":"keep on"}\n'
else
    printf '{"text":""}\n'
fi
