#!/bin/zsh

# Simply start livestreamer on the given stream name in best quality and detach the process from the terminal

if [ $# -ne 1 ]; then
    echo "Missing parameter : stream name"
else
    # I cannot use (only) &! here because it gets handled differently than nohup and will actually kill livestreamer.
    nohup livestreamer twitch.tv/$1 best > /dev/null 2>&1 &
fi
