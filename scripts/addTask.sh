if [[ $# == 0 ]]; then
    read taskText
else
    taskText="$@"
fi
if [[ $taskText == *"proj:"* ]]; then
    task add "$taskText"
    exit 0
else
    projects=$(task rc.context=none allProjects | head -n -3 | tail -n +4 | uniq)
    project=$(echo "$projects" | fzf)
    task add proj:$project $taskText
fi
