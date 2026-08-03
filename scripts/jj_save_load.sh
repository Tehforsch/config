#!/usr/bin/env bash

set -euo pipefail

action=${1:-}
workspace_root=${JJ_WORKSPACE_ROOT:-$(jj root)}
repo_name=${workspace_root%/}
repo_name=${repo_name##*/}
save_dir=${XDG_DATA_HOME:-"$HOME/.local/share"}/jj_saves/$repo_name

case "$action" in
    save)
        mkdir -p "$save_dir"

        operation_id=$(jj op log --reversed --limit 1 -T 'self.id()' --no-graph)
        save_name=$(date +'%s.%N')
        save_file="$save_dir/$save_name"
        printf '%s\n' "$operation_id" > "$save_file"

        printf 'Wrote %.12s to %s\n' "$operation_id" "$save_name"
        ;;
    load)
        if [[ ! -d $save_dir ]]; then
            printf 'No saved operations found for repository %s.\n' "$repo_name" >&2
            exit 1
        fi

        save_file=$(find "$save_dir" -maxdepth 1 -type f -printf '%f\n' | sort | tail -n 1)
        if [[ -z $save_file ]]; then
            printf 'No saved operations found for repository %s.\n' "$repo_name" >&2
            exit 1
        fi

        save_name=$save_file
        save_file="$save_dir/$save_name"
        operation_id=$(<"$save_file")
        if [[ ! $operation_id =~ ^[[:xdigit:]]+$ ]]; then
            printf 'Invalid operation ID in %s.\n' "$save_file" >&2
            exit 1
        fi

        saved_at=${save_name%%.*}
        printf 'Loading %s\n' "$(date --date="@$saved_at" '+%a %-d %b %Y, %H:%M:%S')"
        jj op restore "$operation_id"
        ;;
    *)
        printf 'Usage: %s {save|load}\n' "${0##*/}" >&2
        exit 2
        ;;
esac
