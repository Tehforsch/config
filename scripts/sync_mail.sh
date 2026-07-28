#!/usr/bin/env sh
set -eu

mbsync_cmd="${MBSYNC:-/run/current-system/sw/bin/mbsync}"
notmuch_cmd="${NOTMUCH:-/run/current-system/sw/bin/notmuch}"

mkdir -p "$HOME/.local/share/mail/posteo"
mkdir -p "$HOME/.local/share/mail/mailbox"
mkdir -p "$HOME/.local/share/mail/strato"

"$mbsync_cmd" -a
"$notmuch_cmd" new
"$notmuch_cmd" tag +work-archive -- 'path:mailbox/archive/**'
"$notmuch_cmd" tag -work-archive -- 'tag:work-archive and not path:mailbox/archive/**'
"$notmuch_cmd" tag +old-address +old-posteo -- 'to:tonipeter@posteo.de'
"$notmuch_cmd" tag +old-address +old-gmail -- 'to:tonipeter92@gmail.com'
