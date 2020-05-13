backupFolder="/home/toni/.backupNotes/"
dayFolder=$(date +"%Y%m%d")
folderName="${backupFolder}${dayFolder}"
echo $folderName
if [[ -d $folderName ]]; then
    echo "Backup for today already exists."
    exit
fi
mkdir -p $folderName
cp -rv ~/resource/org/notes/* $folderName
