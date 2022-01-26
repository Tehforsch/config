sysName="$1"
simName=$(basename $(realpath .))
if [[ $sysName == "bwfor" ]]; then
    rsync -rv $bwforWork/$simName/pics .
elif [[ $sysName == "supermuc" ]]; then
    rsync -rv $supermucWork/$simName/pics .
fi
if [[ $? != 0 ]]; then
    echo "FAILED TO COPY FILES - IS SSHFS MOUNTED?"
    exit 1
fi
