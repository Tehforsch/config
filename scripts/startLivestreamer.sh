#!/bin/zsh

# Simply start streamlink on the given stream name in best quality and detach the process from the terminal

if [ $# -ne 1 ]; then
    echo "Missing parameter : stream name"
else
    # I cannot use (only) &! here because it gets handled differently than nohup and will actually kill streamlink.
    nohup streamlink --twitch-oauth-token w61oe302b2dya5ki9zzvcpqqmqlp3o twitch.tv/$1 best 
fi
