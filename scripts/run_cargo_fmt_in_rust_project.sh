#!/usr/bin/env bash

# Check if we're in a Rust project by looking for Cargo.toml
# in current directory or any parent directory
dir="$PWD"
while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/Cargo.toml" ]]; then
        cargo fmt
        exit 0
    fi
    dir=$(dirname "$dir")
done

# No Cargo.toml found, do nothing
exit 0
