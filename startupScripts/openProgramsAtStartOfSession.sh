#!/bin/bash
source ~/.localConfig

# Open telegram
i3-msg workspace 0:chat
i3-msg append_layout ~/projects/config/i3/restore/telegram.json
~/.apps/Telegram/Telegram&

# Open todoist
i3-msg workspace 2:todo
i3-msg append_layout ~/projects/config/i3/restore/todoist.json
$scripts/startChrome.sh --new-window todoist.com&

# Open Gmail + (Thunderbird)
i3-msg workspace 3:mail
if [[ $systemName == "ita" ]]; then
    i3-msg append_layout ~/projects/config/i3/restore/thunderbird.json
    thunderbird&
fi
i3-msg append_layout ~/projects/config/i3/restore/gmail.json
$scripts/startChrome.sh --new-window mail.google.com&

# Spotify wont listen anyways because its obviously a garbage program written by garbage people so just go to the workspace and open it
i3-msg workspace 1:music
spotify&
