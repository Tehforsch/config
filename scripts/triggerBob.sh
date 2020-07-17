command="python3 ~/projects/phd/bob/main.py $@"  
trigger "$command" $(fd ".*.py" ~/projects/phd/bob)
