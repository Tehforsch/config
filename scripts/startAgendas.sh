emacsclient -c -n -e '(progn (setq org-agenda-window-setup (quote current-window)) (personal-agenda))'
dayOfWeek=$(date +%u)
if [ $dayOfWeek == 6 ] || [ $dayOfWeek == 7 ]; then
    exit 0
fi
emacsclient -c -n -e '(progn (setq org-agenda-window-setup (quote current-window)) (work-agenda))'
