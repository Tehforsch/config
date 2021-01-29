(use-package rustic)
(setq rustic-format-on-save t)
(setq rustic-format-display-method 'ignore); Don't show rustfmt buffer

(push 'rustic-clippy flycheck-checkers)
(add-hook 'rustic-mode-hook 'flycheck-mode)
(setq rustic-lsp-server 'rust-analyzer)

(use-package company)
(add-hook 'rustic-mode-hook #'company-mode)
;; (add-hook 'rustic-mode-hook #'racer-mode)
;; (add-hook 'racer-mode-hook #'eldoc-mode)

;; (require 'rust-mode)
;; (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
;; (setq company-tooltip-align-annotations t)

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
