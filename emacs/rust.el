(use-package rustic)
(setenv "PATH" (concat (getenv "PATH") ":/home/toni/.cargo/bin"))
(setq exec-path (append exec-path '("/home/toni/.cargo/bin")))
(setq rustic-format-on-save nil)
(setq rustic-format-display-method 'ignore); Don't show rustfmt buffer

(add-hook 'rustic-mode-hook 'flycheck-mode)
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-analyzer-command '("rustup run nightly rust-analyzer"))

(add-hook 'rustic-mode-hook #'company-mode)

(define-key rustic-mode-map (kbd "TAB") #'company-indent-or-complete-common)

(add-hook 'conf-space-mode-hook 'backtrace)

(setq lsp-auto-execute-action nil)

(use-package helm-lsp)

;; Like helm-lsp-workspace-symbol but with a prefixed # for the search so that it matches all symbols,
;; not just types

(defun helm-lsp-workspace-all-symbols () 
  (interactive)
  (helm-lsp--workspace-symbol (or (lsp-workspaces)
                                  (gethash (lsp-workspace-root default-directory)
                                           (lsp-session-folder->servers (lsp-session))))
                              "Workspace symbol"
                              "#"))

(defun surround-symbol-with-generic-type ()
  "Surround the symbol at point in <> and begin typing in front. Useful for adding generics."
  (interactive)
  (evil-insert nil nil nil) ; Enter insert at first so that this whole function becomes a single action which will be repeatable with . / undoable with u
  (let* ((text-object (evil-inner-symbol))
         (start (car text-object))
         (end (car (cdr text-object))))
    (evil-surround-region start end nil ?>)))
