#!/bin/bash
args="$@"
if [ "$1" = "build" ]; then
    shift
    args="$@"
    command="clear; cargo rustc $args -- -Awarnings"
elif [ "$1" = "test" ]; then
    command="clear; cargo rustc -- -Awarnings && cargo clippy && cargo test -- --nocapture"
else
    command="clear; cargo rustc -- -Awarnings && cargo clippy && cargo run -- $args"
fi
trigger "$command" $(fd ".*\.rs$")
