; Show line numbers
(add-hook 'prog-mode-hook 'column-number-mode)
(defun enable-line-numbers ()
    (setq display-line-numbers t))
(if (< emacs-major-version 26)
    (add-hook 'prog-mode-hook 'linum-mode)
    (add-hook 'prog-mode-hook 'enable-line-numbers)
)
(global-display-line-numbers-mode +1)

; Hide menu bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

; Hide startup splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

; Stop cursor from blinking
(blink-cursor-mode 0)

; Theme
(use-package gruvbox-theme)
(load-theme 'gruvbox-dark-hard t)

(fringe-mode '(0 . 0))

(use-package all-the-icons)

; Font
(set-frame-font "Source Code Pro 14" nil t)
(set-face-attribute 'default nil :height 130)
