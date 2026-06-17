#!/usr/bin/env bash
set -euo pipefail

work_service="work-vpn.service"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -t 3000 "VPN" "$1"
    fi
}

work_status() {
    if systemctl is-active --quiet "$work_service" 2>/dev/null; then
        printf 'connected\n'
    else
        printf 'disconnected\n'
    fi
}

work_start() {
    if [[ "$(work_status)" == "connected" ]]; then
        notify "Work VPN already connected"
        return 0
    fi

    systemctl --no-ask-password start "$work_service"
    notify "Work VPN started"
}

work_stop() {
    if [[ "$(work_status)" == "disconnected" ]]; then
        notify "Work VPN already disconnected"
        return 0
    fi

    systemctl --no-ask-password stop "$work_service"
    notify "Work VPN stopped"
}

mullvad_status() {
    if ! command -v mullvad >/dev/null 2>&1; then
        printf 'unavailable\n'
        return 1
    fi

    case "$(mullvad status 2>/dev/null)" in
        Connected*) printf 'connected\n' ;;
        *) printf 'disconnected\n' ;;
    esac
}

mullvad_start() {
    mullvad connect
    notify "Mullvad connecting"
}

mullvad_stop() {
    mullvad disconnect
    notify "Mullvad disconnected"
}

usage() {
    printf 'Usage: %s {work|mullvad} [toggle|start|stop|status]\n' "$0" >&2
}

vpn="${1:-}"
action="${2:-toggle}"

case "$vpn:$action" in
    work:toggle)
        if [[ "$(work_status)" == "connected" ]]; then work_stop; else work_start; fi
        ;;
    work:start|work:connect)
        work_start
        ;;
    work:stop|work:disconnect)
        work_stop
        ;;
    work:status)
        work_status
        ;;
    mullvad:toggle)
        if [[ "$(mullvad_status)" == "connected" ]]; then mullvad_stop; else mullvad_start; fi
        ;;
    mullvad:start|mullvad:connect)
        mullvad_start
        ;;
    mullvad:stop|mullvad:disconnect)
        mullvad_stop
        ;;
    mullvad:status)
        mullvad_status
        ;;
    *)
        usage
        exit 2
        ;;
esac
