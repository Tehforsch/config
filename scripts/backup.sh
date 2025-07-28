exthdd=/mnt/extHdd/
dir=$exthdd/backup
# mkdir $dir
# borg init -e repokey $dir
tempdir=~/downloads/paperless_export
paperless-manage document_exporter "$tempdir"
date=$(date -I)
borg create -v "${dir}::$date" ~/resource $exthdd/pictures/important "$tempdir"
