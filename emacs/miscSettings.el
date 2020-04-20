; Don't ask when opening large files
(setq large-file-warning-threshold nil)

; Don't loop over buffers that are not associated with a file
(add-to-list 'default-frame-alist '(buffer-predicate . buffer-file-name))

; Focus help buffer automatically when using help functions and allow escaping them with escape
;; (evil-set-initial-state 'help-mode 'motion)
(setq help-window-select t)
(add-hook 'help-mode-hook
    (lambda () (evil-define-key 'normal help-mode-map [escape] 'kill-buffer-and-window)))

; Turn on hideshow by default
(add-hook 'c-mode-hook 'hs-minor-mode)

; Immediately debug when any lisp error occurs
(setq debug-on-error t)
(setq pp-escape-newlines nil)
;; (setq debug-on-error nil)

(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

;; (use-package activity-watch-mode)
;; (global-activity-watch-mode)

(use-package frames-only-mode)
(frames-only-mode)
