# FZF settings that i want in my version control
# ALT-C - cd into the selected directory
fzf-cd-home-widget() {
    local cmd="${FZF_ALT_C_COMMAND:-"command fd -t d '.*' ~"}"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    cd "$dir"
    unset dir # ensure this doesn't end up appearing in prompt expansion
    local ret=$?
    zle fzf-redraw-prompt
    return $ret
}
zle     -N    fzf-cd-home-widget

fzf-cd-widget() {
    local cmd="${FZF_ALT_C_COMMAND:-"command fd -t d -I "}"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    cd "$dir"
    unset dir # ensure this doesn't end up appearing in prompt expansion
    local ret=$?
    zle fzf-redraw-prompt
    return $ret
}
zle     -N    fzf-cd-widget
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_DEFAULT_OPTS="--ansi"

rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
                FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                        fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                                --phony -q "$1" \
                                --bind "change:reload:$RG_PREFIX {q}" \
                                --preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	$scripts/openFile.sh "$file"
}
