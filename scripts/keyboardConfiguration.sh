#!/bin/bash
config=/home/toni/projects/config
setxkbmap -layout de -variant nodeadkeys -option caps:escape
xmodmapFile=~/.activeXmodmap 
if [[ -a $xmodmapFile ]]; then
    active=$(cat $xmodmapFile)
else
    active=1
fi
echo "Active xmodmap: $active"
if [[ $1 == "toggle" ]]; then # goto next xmodmap
    if [[ $active == 1 ]]; then
        echo 2 > $xmodmapFile
        active=2
    else
        echo 1 > $xmodmapFile
        active=1
    fi
fi
echo "Active xmodmap: $active"
if [[ $active == 1 ]]; then
    xmodmap $config/xmodmap/xmodmapNormal
else
    xmodmap $config/xmodmap/xmodmapProgramming
fi
