mkdir /run/media/extHdd/backup
# borg init -e repokey /run/media/extHdd/backup

folder="/run/media/extHdd/backup"
date=$(date -I)
borg create "${folder}::$date" ~/archive ~/resource ~/projects ~/notes ~/.local/mail
