sysName="$1"
simName=$(realpath --relative-to ~/projects/phd/work/ .)
echo $simName
if [[ $sysName == "bwfor" ]]; then
    rsync -arv $bwforWork/$simName/pics .
elif [[ $sysName == "supermuc" ]]; then
    rsync -arv $supermucWork/$simName/pics .
fi
if [[ $? != 0 ]]; then
    echo "FAILED TO COPY FILES - IS SSHFS MOUNTED?"
    exit 1
fi
