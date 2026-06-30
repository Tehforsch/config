#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
sound_file="$script_dir/beep.wav"
state_dir="${XDG_RUNTIME_DIR:-/tmp}/timer.sh-${USER:-user}"

usage() {
    printf 'Usage:\n'
    printf '  %s [-n] <duration>\n' "${0##*/}"
    printf '  %s show\n' "${0##*/}"
    printf '  %s kill\n' "${0##*/}"
    printf '\n'
    printf 'Examples: %s 5m, %s 1h, %s -n 30s\n' "${0##*/}" "${0##*/}" "${0##*/}"
}

notify() {
    local title=$1
    local body=$2

    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$body" || true
    fi
}

parse_duration() {
    local value=$1
    local amount unit

    if [[ $value =~ ^([0-9]+)([smh])$ ]]; then
        amount=${BASH_REMATCH[1]}
        unit=${BASH_REMATCH[2]}
    elif [[ $value =~ ^[0-9]+$ ]]; then
        amount=$value
        unit=s
    else
        return 1
    fi

    case "$unit" in
        s) printf '%s\n' "$amount" ;;
        m) printf '%s\n' "$((amount * 60))" ;;
        h) printf '%s\n' "$((amount * 60 * 60))" ;;
    esac
}

format_remaining() {
    local seconds=$1
    local hours minutes

    if ((seconds < 0)); then
        seconds=0
    fi

    hours=$((seconds / 3600))
    minutes=$(((seconds % 3600) / 60))
    seconds=$((seconds % 60))

    if ((hours > 0)); then
        printf '%dh%02dm' "$hours" "$minutes"
    elif ((minutes > 0)); then
        printf '%dm%02ds' "$minutes" "$seconds"
    else
        printf '%ds' "$seconds"
    fi
}

cleanup_timer() {
    local id=${1:-}

    if [[ -n $id ]]; then
        rm -f "$state_dir/$id"
    fi
}

timer_is_running() {
    local pid=$1
    local id=$2
    local command_line

    [[ $pid =~ ^[0-9]+$ ]] || return 1
    kill -0 "$pid" >/dev/null 2>&1 || return 1

    command_line=$(ps -p "$pid" -o args= 2>/dev/null || true)
    [[ $command_line == *"timer.sh --run $id"* ]]
}

process_is_timer() {
    local pid=$1
    local i arg next after_next
    local -a argv=()

    [[ $pid =~ ^[0-9]+$ ]] || return 1
    [[ $pid -ne $$ ]] || return 1
    [[ -r /proc/"$pid"/cmdline ]] || return 1

    mapfile -d '' -t argv <"/proc/$pid/cmdline" 2>/dev/null || return 1

    for i in "${!argv[@]}"; do
        arg=${argv[$i]}

        case "$arg" in
            "$script_dir/timer.sh"|scripts/timer/timer.sh|*/scripts/timer/timer.sh|*/timer/timer.sh)
                next=${argv[$((i + 1))]:-}
                after_next=${argv[$((i + 2))]:-}

                case "$next" in
                    --run)
                        return 0
                        ;;
                    -n)
                        [[ $after_next =~ ^[0-9]+[smh]?$ ]] && return 0
                        ;;
                    *)
                        [[ $next =~ ^[0-9]+[smh]?$ ]] && return 0
                        ;;
                esac
                ;;
        esac
    done

    return 1
}

add_unique_pid() {
    local pid=$1
    local existing

    [[ $pid =~ ^[0-9]+$ ]] || return 0
    [[ $pid -ne $$ ]] || return 0

    for existing in "${timer_pids[@]}"; do
        [[ $existing -eq $pid ]] && return 0
    done

    timer_pids+=("$pid")
}

collect_descendants() {
    local parent=$1
    local child

    while read -r child; do
        [[ -n $child ]] || continue
        collect_descendants "$child"
        add_unique_pid "$child"
    done < <(pgrep -P "$parent" 2>/dev/null || true)
}

run_timer() {
    local id=$1
    local seconds=$2
    local notify_only=$3
    local original_duration=$4

    trap 'cleanup_timer "$id"' EXIT
    trap 'cleanup_timer "$id"; exit 0' INT TERM

    sleep "$seconds"
    cleanup_timer "$id"

    notify "Timer expired" "$original_duration timer is done"

    if [[ $notify_only != 1 ]] && command -v paplay >/dev/null 2>&1 && [[ -f $sound_file ]]; then
        for _ in {1..20}; do
            paplay "$sound_file" >/dev/null 2>&1 || true
        done
    fi
}

show_timers() {
    local now file id pid end remaining output=()

    mkdir -p "$state_dir"
    now=$(date +%s)

    for file in "$state_dir"/*; do
        [[ -e $file ]] || continue
        id=${file##*/}

        read -r pid end _ <"$file" || {
            rm -f "$file"
            continue
        }

        if ! timer_is_running "$pid" "$id" || ((end <= now)); then
            rm -f "$file"
            continue
        fi

        remaining=$((end - now))
        output+=("$(format_remaining "$remaining")")
    done

    printf '%s\n' "${output[*]}"
}

kill_timers() {
    local file id pid proc
    timer_pids=()

    mkdir -p "$state_dir"

    for file in "$state_dir"/*; do
        [[ -e $file ]] || continue
        id=${file##*/}

        read -r pid _ <"$file" || {
            rm -f "$file"
            continue
        }

        if timer_is_running "$pid" "$id" || process_is_timer "$pid"; then
            add_unique_pid "$pid"
        fi

        rm -f "$file"
    done

    for proc in /proc/[0-9]*; do
        pid=${proc##*/}
        if process_is_timer "$pid"; then
            add_unique_pid "$pid"
        fi
    done

    local root_pids=("${timer_pids[@]}")

    for pid in "${root_pids[@]}"; do
        collect_descendants "$pid"
    done

    for pid in "${root_pids[@]}"; do
        kill -KILL -- "-$pid" >/dev/null 2>&1 || true
    done

    for pid in "${timer_pids[@]}"; do
        kill -KILL "$pid" >/dev/null 2>&1 || true
    done
}

start_timer() {
    local notify_only=0
    local duration seconds id end pid

    if [[ ${1:-} == "-n" ]]; then
        notify_only=1
        shift
    fi

    if [[ $# -ne 1 ]]; then
        usage >&2
        exit 2
    fi

    duration=$1
    if ! seconds=$(parse_duration "$duration"); then
        printf 'Invalid duration: %s\n\n' "$duration" >&2
        usage >&2
        exit 2
    fi

    if ((seconds <= 0)); then
        printf 'Duration must be greater than zero.\n' >&2
        exit 2
    fi

    mkdir -p "$state_dir"
    id="$(date +%s)-$$-$RANDOM"
    end=$(($(date +%s) + seconds))

    if command -v setsid >/dev/null 2>&1; then
        nohup setsid "$0" --run "$id" "$seconds" "$notify_only" "$duration" >/dev/null 2>&1 &
    else
        nohup "$0" --run "$id" "$seconds" "$notify_only" "$duration" >/dev/null 2>&1 &
    fi
    pid=$!

    printf '%s %s %s %s\n' "$pid" "$end" "$notify_only" "$duration" >"$state_dir/$id"
}

case "${1:-}" in
    show)
        show_timers
        ;;
    kill)
        kill_timers
        ;;
    --run)
        shift
        run_timer "$@"
        ;;
    -h|--help|"")
        usage
        ;;
    *)
        start_timer "$@"
        ;;
esac
