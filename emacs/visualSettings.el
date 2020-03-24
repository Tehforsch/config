; Show line numbers
(add-hook 'prog-mode-hook 'column-number-mode)
(defun enable-line-numbers ()
    (setq display-line-numbers t))
(if (< emacs-major-version 26)
    (add-hook 'prog-mode-hook 'linum-mode)
    (add-hook 'prog-mode-hook 'enable-line-numbers)
)

; Font size
(set-face-attribute 'default nil :height 130)

; Hide menu bar
(tool-bar-mode -1)
(menu-bar-mode -1)

; Hide startup splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

; Stop cursor from blinking
(blink-cursor-mode 0)

; Theme
(use-package gruvbox-theme)
; Color theme: gruvbox
(load-theme 'gruvbox-dark-hard t)
