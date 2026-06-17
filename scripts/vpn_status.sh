#!/usr/bin/env bash
set -euo pipefail

config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vpn_script="$config_dir/vpn.sh"
active=()

if [[ "$("$vpn_script" work status)" == "connected" ]]; then
    active+=("work")
fi

if [[ "$("$vpn_script" mullvad status 2>/dev/null || true)" == "connected" ]]; then
    active+=("mullvad")
fi

if (( ${#active[@]} == 0 )); then
    printf '{"text":""}\n'
else
    IFS=+
    printf '{"state":"Good","text":"VPN %s"}\n' "${active[*]}"
fi
