(use-package lsp-mode)
(setq lsp-enable-symbol-highlighting nil)

(use-package lsp-ui)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(add-hook 'c-mode-hook lsp-ui-mode)
(add-hook 'c-mode-hook '(lambda (lsp-ui-doc-mode nil)))
(add-hook 'rustic-mode-hook lsp-ui-mode)
