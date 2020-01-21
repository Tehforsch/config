#!/bin/bash
# Start terminal layout
if [[ $# == 1 ]]; then
    latexFileName=$1
else
    echo "Need filename of main latex file!"
    exit 1
fi
touch $latexFileName
withoutExtension=${latexFileName/.tex/}
i3-msg append_layout ~/projects/config/i3/restore/latex.json
~/.bin/terminal --working-directory=$(pwd) -x "sleep 0.8; ~/.trigger/trigger '~/projects/config/scripts/parseLatex.sh $latexFileName' $(fd .\*.tex); zsh"
~/.bin/terminal --working-directory=$(pwd)
okular ${withoutExtension}.pdf&
sleep 0.3
python3 ~/projects/config/i3Contexts/switch.py workspace y --move
nvim $latexFileName
