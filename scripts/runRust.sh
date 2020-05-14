#!/bin/bash
args="$@"
command="cargo clippy; cargo run -- $args"
trigger "$command" $(fd ".*\.rs$")
