(use-package embrace)
(use-package evil-embrace)
(use-package
  evil-surround
  :config

  ; Remap S as an alternative to s
  (evil-define-key 'normal 'global-map (kbd "S") 'evil-surround-region)
  )


(global-evil-surround-mode 1)
(evil-embrace-enable-evil-surround-integration)

(defun my-embrace-with-generic ()
  (let ((fname (read-string "Generic: ")))
    (cons (format "%s<" (or fname "")) ">")))

(embrace-add-pair-regexp
  ?g
  "\\(\\w\\|\\s_\\)+?<"
  ">"
  'my-embrace-with-generic
  (embrace-build-help "generic<" ">"))


; I never write html so this is a saner default for me instead of adding tags
(setq-default evil-surround-pairs-alist
  (push '(?< . ("<" . ">")) evil-surround-pairs-alist))
