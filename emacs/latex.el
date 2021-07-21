(use-package evil-tex)
(defun my-reset-paragraph-variables ()
  (interactive)
  (kill-local-variable 'paragraph-start)
  (kill-local-variable 'paragraph-separate))


(defun set-display-line-numbers ()
  (interactive)
  (setq display-line-numbers t))

(add-hook 'LaTeX-mode-hook 'my-reset-paragraph-variables)
(add-hook 'LaTeX-mode-hook 'set-display-line-numbers)
(add-hook 'LaTeX-mode-hook #'evil-tex-mode)

(setq latex-bin-folder "/opt/texlive/2021/bin/x86_64-linux/")

(setenv "PATH" (concat (getenv "PATH") (s-concat ":" latex-bin-folder)))
(add-to-list 'exec-path latex-bin-folder)
