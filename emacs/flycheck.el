(use-package flycheck-mypy)
(setq flycheck-python-mypy-args '("--disallow-untyped-defs"))
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)

