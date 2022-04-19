export CONFIG=$HOME/projects/config
export config=$CONFIG
export PROJECTS=$HOME/projects
export projects=$PROJECTS
export scripts=$config/scripts

export supermucProjects="/mnt/sshfs/supermucProjects"
export supermucWork="/mnt/sshfs/supermucWork"
export bwforWork="/mnt/sshfs/bwforWork"


# Disables creation of the worlds most annoying directory: __pycache__
export PYTHONDONTWRITEBYTECODE="1"

source ~/projects/config/taskwarrior/aliases
source ~/projects/config/hledger/config.zsh
