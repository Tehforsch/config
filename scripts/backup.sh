mkdir /run/media/extHdd/backup
# borg init -e repokey /run/media/extHdd/backup

folder="/run/media/extHdd/backup"
date=$(date -I)
borg create -v "${folder}::$date" ~/resource ~/projects ~/.local/mail "/home/toni/.local/share/Anki2/User 1/collection.anki2"
