#!/bin/bash
args="$@"
if [ "$1" = "build" ]; then
    command="clear; cargo rustc -- -Awarnings && cargo clippy"
else
    command="clear; cargo rustc -- -Awarnings && cargo clippy && cargo run -- $args"
fi
trigger "$command" $(fd ".*\.rs$")
