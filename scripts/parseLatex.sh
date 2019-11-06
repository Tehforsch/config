#!/bin/bash
if [[ $# == 1 ]]; then
    latexFileName=$1
else
    echo "Need filename of main latex file!"
    exit 1
fi
withoutExtension=${latexFileName/.tex/}
rubber -d -s $latexFileName
