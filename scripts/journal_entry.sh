#!/usr/bin/env bash
set -e

JOURNAL_PATH=~/resource/journal

# If no arguments provided, find the first day without an entry
if [ $# -eq 0 ]; then
    # Start from 30 days ago and work forward to yesterday
    current_date=$(date -d "30 days ago" +%Y-%m-%d)
    days_checked=0
    
    while [ $days_checked -lt 30 ]; do
        folder=$JOURNAL_PATH/$current_date
        entry=$folder/entry.md
        
        # Check if entry doesn't exist or is empty (only whitespace)
        if [ ! -f "$entry" ] || [ ! -s "$entry" ] || [ -z "$(tr -d '[:space:]' < "$entry")" ]; then
            # Found a day without an entry
            weekday=$(date -d "$current_date" +%A)
            echo "Opening entry for: $current_date ($weekday)"
            
            # Show previous day's entry as reference
            prev_date=$(date -d "$current_date - 1 day" +%Y-%m-%d)
            prev_entry=$JOURNAL_PATH/$prev_date/entry.md
            if [ -f "$prev_entry" ] && [ -s "$prev_entry" ]; then
                echo ""
                echo "Previous day ($prev_date):"
                echo "=========================="
                cat "$prev_entry"
                echo ""
                echo "=========================="
                echo ""
            fi
            
            exec "$0" "$current_date"
        fi
        
        # Move to the next day
        current_date=$(date -d "$current_date + 1 day" +%Y-%m-%d)
        days_checked=$((days_checked + 1))
    done
    
    # If we reach here, all last 30 days have entries
    echo "All entries for the last 30 days exist and are non-empty"
    exit 0
fi

date=$(date --date="$@" +%Y-%m-%d)

folder=$JOURNAL_PATH/$date
entry=$folder/entry.md
pics=$folder/pics

mkdir -p $folder
if [  ! -f $entry ]; then
    touch $entry
fi
mkdir -p $pics
$scripts/openVimInKitty.sh $entry

