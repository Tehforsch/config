(global-eldoc-mode -1)

(use-package eldoc-box)
(setq eldoc-box-clear-with-C-g t)

(defun disable-eldoc-mode ()
    (eldoc-mode -1))

(add-hook 'rust-mode-hook 'disable-eldoc-mode)
