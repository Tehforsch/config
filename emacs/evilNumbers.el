; Increase / decrease with C-a, C-x
(use-package evil-numbers)
; C-c + and C-c - to indent / decrease numbers as in vim but with different key bindings
; Since C-x is kinda special we apparently need to remap it to sth else first? Not sure why but some emacs related stuff
(keyboard-translate ?\C-x ?\C-u)
(keyboard-translate ?\C-u ?\C-x)
(global-set-key (kbd "C-a") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-u") 'evil-numbers/dec-at-pt)
