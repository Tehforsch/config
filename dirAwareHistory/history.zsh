HISTORY_FILE=~/.dirAwareHistory
if [[ -a "$HISTORY_FILE" ]]; then
else 
    touch "$HISTORY_FILE"
fi
preexec () echo "$(pwd)" "$1"  >> "$HISTORY_FILE" 
