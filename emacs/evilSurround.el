(use-package embrace)
(use-package evil-embrace)
(use-package
  evil-surround
  :config

  (evil-define-key 'normal 'global-map (kbd "s") 'evil-surround-region)
  (evil-define-key 'normal 'global-map (kbd "S") 'evil-substitute)
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


;; ; I never write html so this is a saner default for me instead of adding tags
;; (setq-default evil-surround-pairs-alist
;;   (push '(?< . ("<" . ">")) evil-surround-pairs-alist))

(with-eval-after-load 'evil-surround
      (evil-add-to-alist
       'evil-surround-pairs-alist
       ?< '("<" . ">")
       ?& '("&" . "")
       ?r '("&" . "")
       ?* '("*" . "")))

; Embrace should not handle these keys because we want evil surround to do it.
(push ?& evil-embrace-evil-surround-keys)
(push ?r evil-embrace-evil-surround-keys)
(push ?* evil-embrace-evil-surround-keys)
