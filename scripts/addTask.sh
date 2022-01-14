if [[ $# == 0 ]]; then
    read taskText
else
    taskText="$@"
    echo "$taskText"
    if [[ $taskText == *"proj:"* ]]; then
        task add "$taskText"
        exit 0
    fi
fi
projects=$(task rc.context=none allProjects | head -n -3 | tail -n +4 | uniq)
project=$(echo "$projects" | fzf)
task add proj:$project $taskText
