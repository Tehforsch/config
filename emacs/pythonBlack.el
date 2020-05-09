(use-package python-black)
(add-hook 'python-mode-hook 'python-black-on-save-mode)
(setq python-black-extra-args '("-l" "160"))
