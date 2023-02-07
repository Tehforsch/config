(use-package embrace)
(use-package evil-embrace)
(use-package
  evil-surround
  :config
  ; Remap s to surround instead of ys. I'll have to get used to not use s to replace characters (cl works as an alternative)
  (evil-define-key
    'normal
    evil-surround-mode-map
    "s"
    'evil-surround-region))

(global-evil-surround-mode 1)
(evil-embrace-enable-evil-surround-integration)

(defun my-embrace-with-function ()
  (let ((fname (read-string "Generic: ")))
    (cons (format "%s<" (or fname "")) ">")))

(embrace-add-pair-regexp
  ?g
  "\\(\\w\\|\\s_\\)+?<"
  ">"
  'my-embrace-with-function
  (embrace-build-help "generic<" ">"))


; I never write html so this is a saner default for me instead of adding tags
(setq-default evil-surround-pairs-alist
  (push '(?< . ("<" . ">")) evil-surround-pairs-alist))
