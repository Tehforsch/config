#!/bin/bash
source ~/.localConfig

# TELEGRAM
i3-msg workspace 7:chat
i3-msg append_layout ~/projects/config/i3/restore/telegram.json
~/.apps/Telegram/Telegram&
sleep 0.8

# TODOIST
i3-msg workspace 8:todo
i3-msg append_layout ~/projects/config/i3/restore/todoist.json
$scripts/startChrome.sh --new-window todoist.com&
sleep 2.0

# THUNDERBIRD
if [[ $systemName == "ita" ]]; then
    i3-msg workspace 9:mail
    i3-msg append_layout ~/projects/config/i3/restore/thunderbird.json
    thunderbird&
    sleep 0.8
fi

# GMAIL
i3-msg workspace 10:gmail
i3-msg append_layout ~/projects/config/i3/restore/gmail.json
$scripts/startChrome.sh --new-window mail.google.com&
sleep 0.8

# ZOTERO
i3-msg workspace 11:zotero
i3-msg append_layout ~/projects/config/i3/restore/zotero.json
~/.apps/Zotero_linux-x86_64/zotero &
sleep 1

# Music
i3-msg workspace 6:music
sleep 0.8
~/.bin/terminal --working-directory=$(pwd) -x "ncmpcpp; zsh"&
