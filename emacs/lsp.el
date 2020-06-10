(use-package lsp-mode
    :hook ((python-mode . lsp)
           (c-mode . lsp)
           (lsp-mode . lsp-enable-which-key-integration)))

(setq lsp-enable-symbol-highlighting nil)

;; (setq lsp-auto-guess-root t) ; This disables the message when opening a new project but I'm not sure its trustworthy?

;; (use-package lsp-ui)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp))))

(setq lsp-pyls-plugins-pycodestyle-enabled nil)

(use-package lsp-ui)

(setq lsp-ui-doc-enable nil
      lsp-ui-peek-enable nil
      lsp-ui-sideline-enable nil
      lsp-ui-imenu-enable nil
      lsp-ui-flycheck-enable t)
