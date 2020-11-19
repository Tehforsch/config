(use-package rustic)
(setq rustic-format-on-save t)
(add-hook 'rustic-mode-hook 'flycheck-mode)
; I hate emacs for this. I dont know why but auto-mode-alist seems to be ignored completely and every now and then .rs files will be opened in other garbage modes
(setq auto-mode-alist (rassq-delete-all 'conf-colon-mode auto-mode-alist))
(setq auto-mode-alist (rassq-delete-all 'image-mode auto-mode-alist))
(setq auto-mode-alist (rassq-delete-all 'm2-mode auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rustic-mode))
