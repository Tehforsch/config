#!/usr/bin/env bash

# Address completion script for aerc using notmuch
# Filters addresses to only show those containing the search term

search_term="$1"

if [ -z "$search_term" ]; then
    exit 0
fi

# Get all addresses from notmuch and filter for those containing the search term
notmuch address '*' | grep -i "$search_term"
