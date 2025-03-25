if [[ $# == 0 ]]; then
    arg="$(pwd)/"
elif [[ -d "$1" ]]; then
    arg="$1/"
else
    arg="$@"
fi

if [[ -d "$arg" ]]; then
    cd "$arg"
    file=$(fzf)
    arg="$arg/$file"
fi

emacsclient -c -n "$arg"
