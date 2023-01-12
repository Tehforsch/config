(use-package rust-mode)

(setenv "PATH" (concat (getenv "PATH") ":/home/toni/.cargo/bin"))
(setq exec-path (append exec-path '("/home/toni/.cargo/bin")))

(defun insert-generic-after-symbol ()
  (interactive)
  (apply #'evil-visual-char (evil-inner-symbol))
  (evil-backward-char)
  (evil-append nil nil nil)
  (insert "<>")
  (left-char 1))


(add-hook 'rust-mode-hook 'eglot-ensure)
