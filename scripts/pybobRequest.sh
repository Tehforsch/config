#!/bin/bash
#inotify does not work via sshfs
origFolder=$(realpath .)
pybobFolder="$HOME/projects/pybob" 
cd $pybobFolder && git checkout .
cd $origFolder
copyRequestFile="$pybobFolder/requestCopy"
touch "$copyRequestFile"
while [ -a "$copyRequestFile" ]; do
    echo -n "."
    sleep 0.1
done
echo ""
~/projects/cpython/python "$pybobFolder/main.py" --post $@
