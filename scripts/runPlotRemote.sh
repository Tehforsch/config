plotFile="$1"
targetFolder="$2"
if [[ "$targetFolder" == "" ]]; then
    targetFolder="."
fi
localWorkFolder=$(realpath ~/projects/phd/work/)
commandFolder=$(realpath /mnt/sshfs/bwforProjects/commands)
relativePath=$(realpath --relative-to="$localWorkFolder" "$targetFolder")
replaced=${relativePath/\//##}
cp "$plotFile" "$commandFolder/$replaced"
# $scripts/getPlots.sh bwfor && pybob replot  --only-new .
