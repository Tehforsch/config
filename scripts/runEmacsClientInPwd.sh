if [[ $# == 0 ]]; then
    # Combined with (setq find-directory-functions 'helm-find-files-1) this will result in fuzzy search in the current directory which is ideal
    emacsclient -c -n "$(pwd)/"
elif [[ -d "$1" ]]; then
    emacsclient -c -n "$1/"
else
    emacsclient -c -n "$@"
fi
