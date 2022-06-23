#!/bin/bash
#inotify does not work via sshfs
copyRequestFile="$HOME/projects/pybob/requestCopy"
touch "$copyRequestFile"
while [ -a "$copyRequestFile" ]; do
    sleep 0.1
done
python3 $HOME/projects/pybob/main.py $@
