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

ivpn_status() {
    if ! command -v ivpn >/dev/null 2>&1; then
        printf 'unavailable\n'
        return 1
    fi

    local status
    status="$(ivpn status 2>/dev/null || true)"
    if awk -F: '$1 ~ /^[[:space:]]*VPN[[:space:]]*$/ && $2 ~ /^[[:space:]]*CONNECTED/ { found=1 } END { exit !found }' <<< "$status"; then
        printf 'connected\n'
    else
        printf 'disconnected\n'
    fi
}

ivpn_start() {
    ivpn connect -fastest -protocol WireGuard
    notify "IVPN connecting"
}

ivpn_stop() {
    ivpn disconnect
    notify "IVPN disconnected"
}

usage() {
    printf 'Usage: %s {work|ivpn} [toggle|start|stop|status]\n' "$0" >&2
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
    ivpn:toggle)
        if [[ "$(ivpn_status)" == "connected" ]]; then ivpn_stop; else ivpn_start; fi
        ;;
    ivpn:start|ivpn:connect)
        ivpn_start
        ;;
    ivpn:stop|ivpn:disconnect)
        ivpn_stop
        ;;
    ivpn:status)
        ivpn_status
        ;;
    *)
        usage
        exit 2
        ;;
esac
