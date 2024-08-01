; Install maintained fork
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

(use-package quelpa-use-package
  :ensure t)



(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t))

(use-package rustic
  :quelpa (rustic :fetcher github
                  :repo "emacs-rustic/rustic"))






(setenv "PATH" (concat (getenv "PATH") ":/home/toni/.cargo/bin"))
(setq exec-path (append exec-path '("/home/toni/.cargo/bin")))
(setq exec-path (append exec-path '("/usr/lib/llvm15/bin")))
(setq rustic-rustfmt-bin "/home/toni/.cargo/bin/rustfmt")
(setq rustic-format-on-save nil)
(setq rustic-format-display-method 'ignore) ; Don't show rustfmt buffer

(add-hook 'rustic-mode-hook 'flycheck-mode)
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-analyzer-command '("rustup run nightly rust-analyzer"))


(setq lsp-auto-execute-action nil)

; Ive had lots of problems with these - check this again in a few versions?
; This might look confusing, but the usual, good diagnostics I get are actually from
; rustics cargo check flycheck backend, as far as I can tell
(setq lsp-rust-analyzer-diagnostics-enable nil)
(setq lsp-rust-features [])

; I had problems when this was set to the default which included --all-features for some reason
(setq rustic-cargo-check-arguments "")
(setq rustic-cargo-check-exec-command "build")

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
