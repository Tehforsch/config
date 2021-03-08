HISTORY_FILE=~/.dirAwareHistory
if [[ -a "$HISTORY_FILE" ]]; then
else 
    touch "$HISTORY_FILE"
fi

preexec () {
    # Only write to our own history file if the command does not start with a space (like HIST_IGNORE_SPACE). This is mostly so that the ugly commands created by history-aware reverse search can be hidden from history (otherwise we enter a cascade of MEGA-DIRECTORY-AWARE commands)
    command="$1"
    initialLetter="$(echo $command | head -c 1)"
    lineToAdd="$(pwd) $command"
    lineExists=$(cat "$HISTORY_FILE" | grep -l "^$lineToAdd$" | wc -l)
    if [[ $lineExists == 0 ]]; then
        if ! [[ "$initialLetter" == " " ]]; then
            echo "$lineToAdd"  >> "$HISTORY_FILE" 
        fi
    fi
}

# # Alternative way to change history storage if the above turns out to not work in the long term.
# # This then requires rewriting of all history-related functions such as up-history etc.
# function zshaddhistory() {
#   emulate -L zsh
#   if ! [[ "$1" =~ "(^ |^ykchalresp|--password)" ]] ; then
#       print -sr -- "${1%%$'\n'}"
#       fc -p
#   else
#       return 1
#   fi
# }
