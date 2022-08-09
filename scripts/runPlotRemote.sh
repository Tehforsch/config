#inotify does not work via sshfs
pybobDir=~/projects/pybob
pybobRemoteDir=/mnt/sshfs/bwforProjects/pybob
path=$(pwd)
cd "$pybobDir"
for f in $(git diff --name-only) $(git ls-files --others --exclude-standard); do
    cp "$pybobDir/$f" "$pybobRemoteDir/$f"
done
cd "$path"
commFolder=/mnt/sshfs/bwforProjects/commands 
localWorkFolder=/home/toni/projects/phd/work/ 
remoteWorkFolder=/mnt/sshfs/bwforWork/
plotFile="${@: -1}"
if [[ -f "$plotFile" ]]; then
    python3 ~/projects/pybob/main.py remotePlot $commFolder $remoteWorkFolder $localWorkFolder $@
else
    file=$(fd ".*" /home/toni/projects/phd/plots | fzf)
    python3 ~/projects/pybob/main.py remotePlot $commFolder $remoteWorkFolder $localWorkFolder $@ "$file"
fi
