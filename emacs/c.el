(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'lsp-mode)
;; (add-hook 'c-mode-hook '(lambda (hide-ifdef-mode nil)))
;; (add-hook 'c-mode-hook '(lambda (setq default-tab-width 4)))

(setq ccls-enable-skipped-ranges nil)
