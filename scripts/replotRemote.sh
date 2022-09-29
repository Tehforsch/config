#inotify does not work via sshfs
pybobDir=~/projects/pybob
pybobRemoteDir=/mnt/sshfs/bwforProjects/pybob
path=$(pwd)
commFolder=/mnt/sshfs/bwforProjects/commands 
localWorkFolder=/home/toni/projects/phd/work/ 
remoteWorkFolder=/mnt/sshfs/bwforWork/
python3 ~/projects/pybob/main.py watchReplot $commFolder $remoteWorkFolder $localWorkFolder $path
