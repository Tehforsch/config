(use-package rustic)
(setenv "PATH" (concat (getenv "PATH") ":/home/toni/.cargo/bin"))
(setq exec-path (append exec-path '("/home/toni/.cargo/bin")))
(setq rustic-rustfmt-bin "/usr/bin/rustfmt")
(setq rustic-format-on-save nil)
(setq rustic-format-display-method 'ignore); Don't show rustfmt buffer

(add-hook 'rustic-mode-hook 'flycheck-mode)
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-analyzer-command '("rustup run nightly rust-analyzer"))

(add-hook 'rustic-mode-hook #'company-mode)

(define-key rustic-mode-map (kbd "TAB") #'company-indent-or-complete-common)

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

; Ive had lots of problems with these - check this again in a few versions?
(setq lsp-rust-analyzer-diagnostics-enable nil)
(setq lsp-rust-features [])

(defun insert-generic-after-symbol ()
  (interactive)
  (apply #'evil-visual-char (evil-inner-symbol))
  (evil-backward-char)
  (evil-append nil nil nil)
  (insert "<>")
  (left-char 1))
