# https://stackoverflow.com/questions/61075356/zle-reset-prompt-not-cleaning-the-prompt
up-directory() {
    builtin cd ..
    if (( $? == 0 )); then
        local precmd
        for precmd in $precmd_functions; do
            $precmd
        done
        zle reset-prompt
    fi
}

zle -N up-directory

bindkey '^j' up-directory
