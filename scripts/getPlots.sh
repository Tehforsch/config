sysName="$1"
simName=$(realpath --relative-to ~/projects/phd/work/ .)
echo $simName
if [[ $sysName == "bwfor" ]]; then
    output=$(rsync --out-format="%n" -ar $bwforWork/$simName/pics .)
elif [[ $sysName == "supermuc" ]]; then
    output=$(rsync --out-format="%n" -ar $supermucWork/$simName/pics .)
fi
if [[ $? != 0 ]]; then
    echo "FAILED TO COPY FILES - IS SSHFS MOUNTED?"
    exit 1
fi
for f in $(echo $output | tail -n 1); do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    if [[ "$extension" == "png" ]] ; then
        echo "$f"
        kitty +kitten icat --silent --transfer-mode file "$f"
    fi
done
