#!/bin/bash
subcmd="$1"
shift
args="$@"
if [ "$subcmd" = "build" ]; then
    command="clear; cargo rustc $args -- -Awarnings"
elif [ "$subcmd" = "test" ]; then
    command="clear; cargo rustc $args -- -Awarnings && cargo test"
elif [ "$subcmd" = "testVerbose" ]; then
    command="clear; cargo test -- --nocapture"
elif [ "$subcmd" = "run" ]; then
    command="clear&& cargo run $args"
else
    echo "subcmd $subcmd not understood"
fi
trigger "$command" $(fd ".*\.rs$")
