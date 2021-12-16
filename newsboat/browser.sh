#!/bin/sh
cd ~/.play
nohup /usr/bin/firefox "$@" 2>&1 > /dev/null &
