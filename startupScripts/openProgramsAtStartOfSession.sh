#!/bin/bash
source ~/.localConfig

# TELEGRAM
i3-msg workspace 6:chat
i3-msg append_layout ~/projects/config/i3/restore/telegram.json
telegram-desktop&
sleep 0.8

# TODOIST
i3-msg workspace 8:todo
i3-msg append_layout ~/projects/config/i3/restore/todoist.json
firefox --new-window todoist.com&
sleep 2.0

# NOTES
i3-msg workspace 9:notes
i3-msg append_layout ~/projects/config/i3/restore/notes.json
emacsclient -c -n
sleep 0.3

# THUNDERBIRD
if [[ $systemName == "ita" ]]; then
    i3-msg workspace 10:mail
    i3-msg append_layout ~/projects/config/i3/restore/thunderbird.json
    thunderbird&
    sleep 0.8
else
    # GMAIL
    i3-msg append_layout ~/projects/config/i3/restore/gmail.json
    firefox --new-window mail.google.com&
    sleep 0.8
fi


# ZOTERO
i3-msg workspace 11:zotero
i3-msg append_layout ~/projects/config/i3/restore/zotero.json
~/.apps/Zotero_linux-x86_64/zotero &
sleep 1

# Music
i3-msg workspace 7:music
sleep 0.8
kitty "ncmpcpp"&
