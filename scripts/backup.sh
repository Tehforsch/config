exthdd=/mnt/extHdd/
dir=$exthdd/backup
mkdir $dir
# borg init -e repokey /run/media/extHdd/backup

date=$(date -I)
borg create -v "${dir}::$date" ~/resource $exthdd/pictures
