; Show line numbers
(add-hook 'prog-mode-hook 'column-number-mode)
(defun enable-line-numbers ()
  (setq display-line-numbers t))
(if (< emacs-major-version 26)
  (add-hook 'prog-mode-hook 'linum-mode)
  (add-hook 'prog-mode-hook 'enable-line-numbers))
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
(load-theme 'gruvbox-light-medium t)

(fringe-mode '(0 . 0))

(use-package all-the-icons)

(if (> (display-pixel-height) 1080)
  (progn
    (add-to-list 'default-frame-alist '(font . "Inconsolata 20")))
  (progn
    (add-to-list 'default-frame-alist '(font . "Inconsolata 20"))))


(global-hl-line-mode 1)

; Allow temporarily increasing font size, which is nice sometimes
(use-package default-text-scale)
(define-key
  evil-normal-state-map
  (kbd "C-*")
  'default-text-scale-increase)
(define-key
  evil-normal-state-map
  (kbd "C-_")
  'default-text-scale-decrease)

(defun make-frame-delete-window ()
  (interactive)
  (make-frame)
  (delete-window))

; This allows flycheck error messages to be shown without opening a new frame which is very annoying
; Hopefully it won't break anything
(setq max-mini-window-height 1.0)
