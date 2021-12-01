#!/bin/sh
nohup /usr/bin/firefox "$@" & 2>&1 > /dev/null
