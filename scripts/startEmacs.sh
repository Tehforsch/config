#!/bin/bash
if [[ $systemName == "ita" ]]; then
    EMACS_STANDALONE="/usr/bin/emacs26"
    EMACS_CLIENT="/usr/bin/emacsclient26"
else
    EMACS_STANDALONE="emacs"
    EMACS_CLIENT="emacsclient"
fi
if [[ $EMACS_TEST == 1 ]]; then
    eval $EMACS_STANDALONE
else
    eval $EMACS_CLIENT --create-frame "$@"
fi
