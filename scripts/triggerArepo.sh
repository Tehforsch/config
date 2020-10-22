command="python3 ~/projects/phd/bob/main.py $@"  
trigger "$command" $(fd ".*.c" ~/projects/phd/arepo)
