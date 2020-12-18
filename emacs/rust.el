(use-package rustic)
(setq rustic-format-on-save t)
(setq rustic-format-display-method 'ignore); Don't show rustfmt buffer

(push 'rustic-clippy flycheck-checkers)
(add-hook 'rustic-mode-hook 'flycheck-mode)
; I hate emacs for this. I dont know why but auto-mode-alist seems to be ignored completely and every now and then .rs files will be opened in other garbage modes
; I found out that this is due to rustfmt being called by rustic upon save. Afterwards the file is reloaded which triggers the find-file-hook. There, the zil/link-file-open-hook is called which sets the conf mode for some reason. I cant be bothered to debug this properly so I just removed the hook. Now files called config.rs have the right mode.
(setq find-file-hook (remove 'zil/link-file-open-hook find-file-hook))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rustic-mode))
(setq rustic-lsp-server 'rust-analyzer)

(use-package company)
(add-hook 'rustic-mode-hook #'company-mode)
;; (add-hook 'rustic-mode-hook #'racer-mode)
;; (add-hook 'racer-mode-hook #'eldoc-mode)

;; (require 'rust-mode)
;; (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
;; (setq company-tooltip-align-annotations t)

(add-hook 'conf-space-mode-hook 'backtrace)
