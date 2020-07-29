(use-package auctex
  :defer t
  :ensure t)

(use-package cdlatex)

(defun my-reset-paragraph-variables ()
  (interactive)
  (kill-local-variable 'paragraph-start)
  (kill-local-variable 'paragraph-separate))

(add-hook 'latex-mode-hook 'my-reset-paragraph-variables)
