#!/bin/bash
ps fax | fzf | awk '{print $1; exit}' | xargs kill
