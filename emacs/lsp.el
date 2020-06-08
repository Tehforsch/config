(use-package lsp-mode
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
            (python-mode . lsp)
            ;; if you want which-key integration
            (lsp-mode . lsp-enable-which-key-integration)))
(setq lsp-enable-symbol-highlighting nil)

;; (use-package lsp-ui)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp))))

;; (add-hook 'c-mode-hook lsp-ui-mode)
;; ;; (add-hook 'c-mode-hook '(lambda () '(lsp-ui-doc-mode nil)))
;; (add-hook 'rustic-mode-hook lsp-ui-mode)
