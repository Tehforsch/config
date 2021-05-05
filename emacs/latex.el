(use-package auctex
  :defer t
  :ensure t)

(use-package cdlatex)

(defun my-reset-paragraph-variables ()
  (interactive)
  (kill-local-variable 'paragraph-start)
  (kill-local-variable 'paragraph-separate))

(add-hook 'latex-mode-hook 'my-reset-paragraph-variables)

(defun set-display-line-numbers ()
  (interactive)
  (setq display-line-numbers t))

(add-hook 'latex-mode-hook 'set-display-line-numbers)

(setq latex-bin-folder "/opt/texlive/2021/bin/x86_64-linux/")

(setenv "PATH" (concat (getenv "PATH") (s-concat ":" latex-bin-folder)))
(add-to-list 'exec-path latex-bin-folder)
