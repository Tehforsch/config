(use-package treemacs)

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile)

(use-package lsp-treemacs)

; Always follow the currently open project
(treemacs-project-follow-mode 1)
