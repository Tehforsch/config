#!/bin/bash
subcmd="$1"
shift
args="$@"
if [ "$subcmd" = "build" ]; then
    command="clear; cargo rustc $args -- -Awarnings"
elif [ "$subcmd" = "test" ]; then
    command="clear; cargo test $args"
elif [ "$subcmd" = "testVerbose" ]; then
    command="clear; cargo test -- --nocapture"
else
    command="clear; cargo rustc -- -Awarnings && cargo clippy && cargo run -- $args"
fi
trigger "$command" $(fd ".*\.rs$")
