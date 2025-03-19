(use-package rustic)
(setq rustic-format-on-save nil)
(setq rustic-format-display-method 'ignore) ; Don't show rustfmt buffer

;; (add-hook 'rustic-mode-hook 'flycheck-mode)
(setq rustic-lsp-server 'rust-analyzer)


(setq lsp-auto-execute-action nil)

; Ive had lots of problems with these - check this again in a few versions?
; This might look confusing, but the usual, good diagnostics I get are actually from
; rustics cargo check flycheck backend, as far as I can tell
(setq lsp-rust-analyzer-diagnostics-enable nil)

(setq lsp-rust-features [])

(defun set-lsp-rust-feature ()
  (interactive)
  (let ((feature (read-from-minibuffer "feature: ")))
    (message feature)
    (setq lsp-rust-no-default-features t)
    (setq lsp-rust-features (vector feature))
    (lsp-restart-workspace)))

(defun set-lsp-rust-no-default-features ()
  (interactive)
  (setq lsp-rust-no-default-features t)
  (lsp-restart-workspace))

(defun set-lsp-rust-default-features ()
  (interactive)
  (setq lsp-rust-features nil)
  (setq lsp-rust-no-default-features nil)
  (lsp-restart-workspace))
