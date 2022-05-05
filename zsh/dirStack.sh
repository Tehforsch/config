setopt autopushd pushdminus pushdsilent pushdtohome

go-up-dir-history() {
    builtin popd
    if (( $? == 0 )); then
        local precmd
        for precmd in $precmd_functions; do
            $precmd
        done
        zle reset-prompt
    fi
}

zle -N go-up-dir-history

# Go up/down the directory stack
bindkey '^o' go-up-dir-history
