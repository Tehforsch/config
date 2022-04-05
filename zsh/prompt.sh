function get_git_info()
{
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
        branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
        if [[ $(git diff --stat) == '' ]]; then
            color="6"
            dirtyString=""
        else
            color="11"
            dirtyString="*"
        fi
        if [[ $branch == "" ]];
        then
            :
        else
            echo '%F{'${color}'}('${dirtyString}${branch}')%f'
        fi
    fi
}

setopt prompt_subst

precmd() { print "" }

PROMPT=$'%B%F{4}%~%f%b $(get_git_info)\n> '
