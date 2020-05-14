(use-package lsp-mode)
(use-package rustic)
(setq rustic-format-on-save t)
(add-hook 'rustic-mode-hook 'flycheck-mode)
