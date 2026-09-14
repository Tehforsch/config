#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: init_envrc [shell]"
    echo
    echo "Without a shell, restore the saved .envrc for the current project."
    echo "With a shell, save and create a standard flake-based .envrc."
}

if [ "$#" -gt 1 ]; then
    usage >&2
    exit 2
fi

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

project_name="${PWD##*/}"
direnv_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
definitions_file="$direnv_dir/envrcs.json"
envrc_file="$PWD/.envrc"

if [ "$#" -eq 1 ]; then
    shell_name="$1"
    definition="use flake ~/projects/config/nixos/shells#$shell_name"$'\n'
    temporary_file=$(mktemp --tmpdir="$direnv_dir" .envrcs.json.XXXXXX)
    trap 'rm -f -- "$temporary_file"' EXIT

    jq --arg project "$project_name" --arg definition "$definition" \
        '. + {($project): $definition} | to_entries | sort_by(.key) | from_entries' \
        "$definitions_file" > "$temporary_file"
    chmod --reference="$definitions_file" "$temporary_file"
    mv -- "$temporary_file" "$definitions_file"
    trap - EXIT
    echo "Saved envrc definition for '$project_name' using shell '$shell_name'."
elif ! jq -e --arg project "$project_name" 'has($project)' "$definitions_file" >/dev/null; then
    echo "No envrc definition found for '$project_name'." >&2
    echo "Run init_envrc with the desired shell, for example:" >&2
    echo "  init_envrc rust_stable" >&2
    echo "  init_envrc bevy" >&2
    exit 1
fi

if [ -L "$envrc_file" ]; then
    rm -- "$envrc_file"
fi

jq -jr --arg project "$project_name" '.[$project]' "$definitions_file" > "$envrc_file"
direnv allow "$envrc_file"
echo "Created $envrc_file"
