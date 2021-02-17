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
(setq debug-on-error nil)
(defun lisp-debug-settings () 
    (setq debug-on-error t)
    (setq pp-escape-newlines nil)
    (use-package erefactor)
    (erefactor-highlight-mode nil))

(use-package frames-only-mode)
(frames-only-mode)

(defun save-file-and-run-last-command-in-terminal-to-the-right ()
  (interactive)
  (save-buffer-always)
  (shell-command "~/projects/config/scripts/runLastCommandInTerminalToTheRight.sh"))

; Make sure that things copied from the system clipboard arent lost when we kill something in emacs. This has made my life so much better.
(set save-interprogram-paste-before-kill t)
