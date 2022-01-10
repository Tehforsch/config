sysName="$1"
simName=$(basename $(realpath .))
if [[ $sysName == "bwfor" ]]; then
    rsync -rv $bwforWork/$simName/pics .
elif [[ $sysName == "supermuc" ]]; then
    rsync -rv $supermucWork/$simName/pics .
fi
