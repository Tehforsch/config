#!/usr/bin/env bash
set -uo pipefail

lock_file="${XDG_RUNTIME_DIR:-/run/user/$UID}/i3-center-floating-windows.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

center_window() {
    local container_id=$1
    local floating_state

    sleep 0.2
    floating_state=$(
        i3-msg -t get_tree |
            jq -r --arg container_id "$container_id" \
                '.. | objects | select((.id? | tostring) == $container_id) | .floating // empty'
    )

    if [[ "$floating_state" == "user_on" ]]; then
        i3-msg "[con_id=$container_id] move position center" >/dev/null
    fi
}

subscribe() {
    i3-msg -t subscribe -m '["window"]' |
        jq --unbuffered -r \
            'select(.change == "new" or .change == "floating") | .container.id' |
        while IFS= read -r container_id; do
            center_window "$container_id" &
        done
}

while true; do
    subscribe || true
    sleep 1
done
