super-dir-widget () {
    zle kill-whole-line
    BUFFER="cd .."
    zle .accept-line
}
zle -N super-dir-widget
