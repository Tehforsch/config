projects=$(task rc.context=none allProjects | head -n -3 | tail -n +4 | uniq)
project=$(echo "$projects" | fzf)
read taskText
task add proj:$project $taskText
