#!/bin/bash
EMACS_STANDALONE="emacs"
EMACS_CLIENT="emacsclient"
if [[ $EMACS_TEST == 1 ]]; then
    eval $EMACS_STANDALONE
else
    eval $EMACS_CLIENT --create-frame "$@"
fi
