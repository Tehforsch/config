#!/bin/bash
# Start terminal layout
if [[ $# == 1 ]]; then
    pythonFileName=$1
else
    echo "Need filename of main python file!"
    exit 1
fi
touch $pythonFileName
~/.bin/terminal --working-directory=$(pwd) -x "~/.trigger/trigger 'python3 $pythonFileName \*.py'; zsh"
nvim $pythonFileName
