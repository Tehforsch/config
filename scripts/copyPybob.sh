#inotify does not work via sshfs
pybobDir=~/projects/pybob
pybobRemoteDir=/mnt/sshfs/bwforProjects/pybob
copyRequestFile="$pybobRemoteDir/requestCopy"
cd "$pybobDir"
while [[ 1 ]]; do
    sleep 1
    if [[ -a "$copyRequestFile" ]]; then
        echo "Copy requested"
        for f in $(git diff --name-only) $(git ls-files --others --exclude-standard); do
            echo $f
            cp "$pybobDir/$f" "$pybobRemoteDir/$f"
        done
        rm "$copyRequestFile"
    fi
done
