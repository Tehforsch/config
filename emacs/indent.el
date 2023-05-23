(defun my-inhibit-electric-indent ()
    (interactive)
    (setq electric-indent-inhibit t))

(add-hook 'c-mode-hook 'my-inhibit-electric-indent)
(add-hook 'python-mode-hook 'my-inhibit-electric-indent)
(add-hook 'fundamental-mode-hook 'my-inhibit-electric-indent)
(add-hook 'lisp-interaction-mode 'my-inhibit-electric-indent)
(add-hook 'org-mode-hook 'my-inhibit-electric-indent)
