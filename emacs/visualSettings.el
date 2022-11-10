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

(if (> (display-pixel-height) 1080)
    (progn
        (add-to-list 'default-frame-alist
                    '(font . "Inconsolata 13")))
    (progn
        (add-to-list 'default-frame-alist
                    '(font . "Inconsolata 14"))))


(global-hl-line-mode 1)
(set-face-background hl-line-face "gray16")

; Allow temporarily increasing font size, which is nice sometimes
(use-package default-text-scale)
(define-key evil-normal-state-map (kbd "C-*") 'default-text-scale-increase)
(define-key evil-normal-state-map (kbd "C-_") 'default-text-scale-decrease)

(use-package rainbow-delimiters)
(add-hook 'rustic-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode 'rainbow-delimiters-mode)
(add-hook 'python-mode 'rainbow-delimiters-mode)
