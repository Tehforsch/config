ps -e | fzf | awk '{print $1; exit}' | xargs kill -KILL
