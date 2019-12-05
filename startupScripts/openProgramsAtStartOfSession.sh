#!/bin/bash
source ~/.localConfig

# TELEGRAM
python3 ~/projects/config/i3Contexts/switch.py workspace chat
i3-msg append_layout ~/projects/config/i3/restore/telegram.json
~/.apps/Telegram/Telegram&
sleep 0.3

# TODOIST
python3 ~/projects/config/i3Contexts/switch.py workspace todo
i3-msg append_layout ~/projects/config/i3/restore/todoist.json
$scripts/startChrome.sh --new-window todoist.com&
sleep 0.8

# THUNDERBIRD
if [[ $systemName == "ita" ]]; then
    python3 ~/projects/config/i3Contexts/switch.py workspace mail
    i3-msg append_layout ~/projects/config/i3/restore/thunderbird.json
    thunderbird&
    sleep 0.8
fi

# GMAIL
python3 ~/projects/config/i3Contexts/switch.py workspace gmail
i3-msg append_layout ~/projects/config/i3/restore/gmail.json
$scripts/startChrome.sh --new-window mail.google.com&
sleep 0.8

# ZOTERO
python3 ~/projects/config/i3Contexts/switch.py workspace zotero
i3-msg append_layout ~/projects/config/i3/restore/zotero.json
~/.apps/Zotero_linux-x86_64/zotero &
sleep 1

# Music
python3 ~/projects/config/i3Contexts/switch.py workspace music
~/.bin/terminal --working-directory=$(pwd) -x "ncmpcpp; zsh"&
