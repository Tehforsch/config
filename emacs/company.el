(use-package company)
(add-hook 'rustic-mode 'company-mode)
(with-eval-after-load 'company (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
(setq company-backends #'(company-bbdb company-semantic company-cmake company-capf company-clang company-files (company-dabbrev-code company-gtags company-etags) company-oddmuse company-dabbrev))
