if [ $# = 0 ]
then 
    gnome-terminal -e "zsh -c1 'python3.4 ~/projects/makeRunView/main.py -v .;exec $SHELL'"
elif [ $# = 1 ]
then
    # Open pdf in okular and make nohup shut up then open makeRunView
    gnome-terminal -e "zsh -c \"i3-msg 'workspace 1' && nohup okular $1 >/dev/null 2>&1 &;python3.4 ~/projects/makeRunView/main.py -v .;exec $SHELL\""
fi

vim
