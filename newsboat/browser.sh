#!/bin/sh
mkdir -p ~/.playground/newsboatcache
cd ~/.playground/newsboatcache
nohup firefox "$@" >/dev/null 2>&1 &
