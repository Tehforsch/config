sysName="$1"
simName=$(realpath --relative-to ~/projects/phd/work/ .)
echo $simName
if [[ $sysName == "bwfor" ]]; then
    rsync -rv $bwforWork/$simName/pics .
elif [[ $sysName == "supermuc" ]]; then
    rsync -rv $supermucWork/$simName/pics .
fi
if [[ $? != 0 ]]; then
    echo "FAILED TO COPY FILES - IS SSHFS MOUNTED?"
    exit 1
fi
