#!/usr/bin/env bash

set -euo pipefail

if command -v jj >/dev/null && jj root >/dev/null 2>&1; then
    is_empty="$(jj log -r @ --no-graph --color=never -T 'empty' 2>/dev/null)"
    if [[ "$is_empty" == "false" ]]; then
        jj new >/dev/null 2>&1
    fi
fi

printf '{}\n'
