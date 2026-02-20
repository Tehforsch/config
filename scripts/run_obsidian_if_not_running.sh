#!/usr/bin/env bash

if ps -ef | grep electron | grep obsidian | grep -q .; then
  echo "Obsidian is running"
  exit 0
fi

exec obsidian
