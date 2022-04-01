#!/bin/sh
cd ~/.play
nohup /usr/bin/firefox "$@" >/dev/null 2>&1 &
