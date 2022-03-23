function launch {
    nohup "$@" >/dev/null 2>/dev/null & disown
}

launch-widget () {
    BUFFER="launch $BUFFER"
    zle .accept-line
}
zle -N launch-widget

bindkey '^g' launch-widget
