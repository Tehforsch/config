#!/bin/zsh

if [ $# != 2 ]; then
    echo "Needs two arguments: todo folder and task"
    exit 1
fi
echo "$2" >> "$HOME/resource/todo/$1/nextActions"
