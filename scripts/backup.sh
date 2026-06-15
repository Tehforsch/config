exthdd=/mnt/extHdd1/
dir=$exthdd/backup
# mkdir $dir
# borg init -e repokey $dir
tempdir=~/downloads/paperless_export
mkdir -p $tempdir
paperless-manage document_exporter "$tempdir"
date=$(date -I)
borg create -v "${dir}::$date" ~/resource $exthdd/archive $tempdir ~/.local/share/paperless/ ~/.local/share/todo/ ~/.local/share/mail
