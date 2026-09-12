#!/usr/bin/env bash

set -euo pipefail

readonly vm_name="abox"
readonly projects_root="/home/toni/projects"
readonly ssh_target="vsock/42"
readonly ssh_user="toni"
readonly service="microvm@$vm_name.service"
readonly systemctl="/run/current-system/sw/bin/systemctl"

ssh_options=(
    -o ConnectTimeout=1
    -o LogLevel=ERROR
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
)

usage() {
    echo "usage: abox [run [PROJECT_DIRECTORY]|login|shell|start|stop]" >&2
}

start() {
    sudo "$systemctl" start "$service"

    for _ in $(seq 1 150); do
        if ssh "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" true 2>/dev/null; then
            return
        fi
        sleep 0.2
    done

    "$systemctl" status --no-pager "$service" || true
    return 1
}

run() {
    local directory
    directory=$(realpath "${1:-.}")

    case "$directory" in
        "$projects_root"|"$projects_root"/*) ;;
        *)
            echo "$directory is not mounted in abox" >&2
            return 1
            ;;
    esac

    local quoted_directory
    printf -v quoted_directory %q "$directory"
    exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" \
        "cd -- $quoted_directory && { direnv allow 2>/dev/null || true; } && exec direnv exec . codex --dangerously-bypass-approvals-and-sandbox"
}

command="${1:-run}"
if (($# > 0)); then
    shift
fi

case "$command" in
    run)
        if (($# > 1)); then
            usage
            exit 2
        fi
        start
        run "${1:-.}"
        ;;
    login)
        start
        exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" "codex login --device-auth"
        ;;
    shell)
        start
        exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target"
        ;;
    start)
        start
        ;;
    stop)
        exec sudo "$systemctl" stop "$service"
        ;;
    help|-h|--help)
        usage
        ;;
    *)
        usage
        exit 2
        ;;
esac
