#!/bin/bash
#inotify does not work via sshfs
copyRequestFile="$HOME/projects/pybob/requestCopy"
touch "$copyRequestFile"
while [ -a "$copyRequestFile" ]; do
    echo -n "."
    sleep 0.1
done
echo ""
python3 $HOME/projects/pybob/main.py $@
