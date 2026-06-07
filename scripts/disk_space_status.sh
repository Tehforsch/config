#!/usr/bin/env bash
set -euo pipefail

path="${1:-/}"
threshold="${2:-10}"

read -r available_percent available_human < <(
    df --output=pcent,avail -h "$path" | awk 'NR == 2 {
        used = $1
        sub(/%$/, "", used)
        print 100 - used, $2
    }'
)

if ((available_percent > threshold)); then
    printf '{"text":""}\n'
    exit 0
fi

printf '{"icon":"disk_drive","state":"Critical","text":"%s"}\n' "$available_human"
