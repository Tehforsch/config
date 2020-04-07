; Don't ask when opening large files
(setq large-file-warning-threshold nil)

; Don't loop over buffers that are not associated with a file
(set-frame-parameter nil 'buffer-predicate #'buffer-file-name)

; Focus help buffer automatically when using help functions and allow escaping them with escape
;; (evil-set-initial-state 'help-mode 'motion)
(setq help-window-select t)
(add-hook 'help-mode-hook
    (lambda () (evil-define-key 'normal help-mode-map [escape] 'kill-buffer-and-window)))

; Turn on hideshow by default
(hs-minor-mode)
