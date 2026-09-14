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
    echo "usage: abox [run PROMPT...|review|resume|login|shell|start|stop]" >&2
}

start_vm() {
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

sync_codex() {
    local source="${CODEX_HOME:-$HOME/.codex}"
    local entries=()

    for entry in config.toml AGENTS.md AGENTS.override.md rules skills; do
        if [[ -e "$source/$entry" || -L "$source/$entry" ]]; then
            entries+=("$entry")
        fi
    done

    local profile
    for profile in "$source"/*.config.toml; do
        if [[ -f "$profile" ]]; then
            entries+=("${profile##*/}")
        fi
    done

    if ((${#entries[@]} == 0)); then
        return
    fi

    tar -C "$source" --dereference --exclude='skills/.system' -cf - "${entries[@]}" \
        | ssh "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" \
            'umask 077; mkdir -p "$HOME/.codex"; tar -xf - -C "$HOME/.codex"'
}

prepare_vm() {
    start_vm
    sync_codex
}

resolve_directory() {
    local directory
    directory=$(realpath .)

    case "$directory" in
        "$projects_root"|"$projects_root"/*) ;;
        *)
            echo "$directory is not mounted in abox" >&2
            return 1
            ;;
    esac

    printf '%s\n' "$directory"
}

quote_command() {
    local command=""
    local argument

    for argument in "$@"; do
        printf -v argument '%q' "$argument"
        command+=" $argument"
    done

    printf '%s\n' "${command# }"
}

run_interactive() {
    local directory
    directory=$(resolve_directory)

    local quoted_directory
    printf -v quoted_directory %q "$directory"
    exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" \
        "cd -- $quoted_directory && { direnv allow 2>/dev/null || true; } && exec direnv exec . codex --dangerously-bypass-approvals-and-sandbox"
}

run_detached() {
    local prompt="$1"
    local directory
    directory=$(resolve_directory)

    local unit
    unit="abox-codex-$(date +%Y%m%d-%H%M%S)-$$-$RANDOM"
    local remote_command
    remote_command=$(quote_command \
        systemd-run \
        --user \
        --quiet \
        --collect \
        "--unit=$unit" \
        "--working-directory=$directory" \
        /run/current-system/sw/bin/bash \
        -c \
        "{ /run/current-system/sw/bin/direnv allow 2>/dev/null || true; } && exec /run/current-system/sw/bin/direnv exec . /run/current-system/sw/bin/codex exec --dangerously-bypass-approvals-and-sandbox -- \"\$1\"" \
        abox-codex \
        "$prompt")

    ssh "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" "$remote_command"
    echo "Started $unit in $directory"
}

resume() {
    local directory
    directory=$(resolve_directory)

    local quoted_directory
    printf -v quoted_directory %q "$directory"
    exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" \
        "cd -- $quoted_directory && { direnv allow 2>/dev/null || true; } && exec direnv exec . codex resume --include-non-interactive --dangerously-bypass-approvals-and-sandbox"
}

run_review() {
    local directory
    directory=$(resolve_directory)

    local quoted_directory
    printf -v quoted_directory %q "$directory"
    exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" \
        "cd -- $quoted_directory && { direnv allow 2>/dev/null || true; } && exec direnv exec . codex review --base main"
}

if (($# == 0)); then
    prepare_vm
    run_interactive
fi

command="$1"
shift

case "$command" in
    run)
        if (($# == 0)); then
            usage
            exit 2
        fi
        if [[ "$1" == "--detach" ]]; then
            echo "abox run always detaches; remove --detach" >&2
            exit 2
        fi
        prepare_vm
        run_detached "$*"
        ;;
    review)
        if (($# > 0)); then
            usage
            exit 2
        fi
        prepare_vm
        run_review
        ;;
    resume)
        if (($# > 0)); then
            usage
            exit 2
        fi
        prepare_vm
        resume
        ;;
    login)
        if (($# > 0)); then
            usage
            exit 2
        fi
        prepare_vm
        exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target" "codex login --device-auth"
        ;;
    shell)
        if (($# > 0)); then
            usage
            exit 2
        fi
        prepare_vm
        exec ssh -t "${ssh_options[@]}" -l "$ssh_user" "$ssh_target"
        ;;
    start)
        if (($# > 0)); then
            usage
            exit 2
        fi
        prepare_vm
        ;;
    stop)
        if (($# > 0)); then
            usage
            exit 2
        fi
        exec sudo "$systemctl" stop "$service"
        ;;
    help|-h|--help)
        if (($# > 0)); then
            usage
            exit 2
        fi
        usage
        ;;
    *)
        usage
        exit 2
        ;;
esac
