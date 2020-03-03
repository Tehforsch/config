if [[ $systemName == "ita" ]]; then
    EMACS_STANDALONE="/usr/bin/emacs26"
    EMACS_CLIENT="/usr/bin/emacsclient26"
else
    EMACS_STANDALONE="emacs"
    EMACS_CLIENT="emacsclient"
fi
if [[ $EMACS_TEST == 1 ]]; then
    $($EMACS_STANDALONE)
else
    $($EMACS_CLIENT --create-frame --alternate-editor='')
fi
