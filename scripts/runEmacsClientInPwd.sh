if [[ $# == 0 ]]; then
    # Combined with (setq find-directory-functions 'helm-find-files-1) this will result in fuzzy search in the current directory which is ideal
    emacsclient -c -n "$(pwd)/"
else
    emacsclient -c -n "$@"
fi
