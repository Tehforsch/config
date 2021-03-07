fzf-dir-aware-history-widget() {
    # local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
    keyDirAndCommand=$(cat ~/.dirAwareHistory | tac | uniq | fzf --expect=ctrl-t --tiebreak=index --with-nth=2.. --delimiter=" ")
    key=$(echo "$keyDirAndCommand" | head -n 1)
    dirAndCommand=$(echo "$keyDirAndCommand" | tail -n 1)
    dir=${${(z)dirAndCommand}[1]} # First word
    command=${${(z)dirAndCommand}[2,-1]} # Rest

    if [[ "$key" == "ctrl-t" ]]; then 
        pwdBefore=$(pwd)
        cd "$dir"
        eval ${command}
        cd "$pwdBefore"
    else 
        eval ${command}
    fi

    zle kill-whole-line
    BUFFER="$command"

    zle send-break
}
zle -N fzf-dir-aware-history-widget
