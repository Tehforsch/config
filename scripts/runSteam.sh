#!/usr/bin/env sh
mkdir $HOME/.local/state/steam_garbage
HOME=$HOME/.local/state/steam_garbage
exec /usr/bin/steam "$@"
