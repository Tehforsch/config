(use-package evil-surround
    :config
; Remap s to surround instead of ys. I'll have to get used to not use s to replace characters (cl works as an alternative)
    (evil-define-key 'normal evil-surround-mode-map "s" 'evil-surround-region)
)
(global-evil-surround-mode 1)

(defun my-evil-surround-generic ()
  "Read a generic name from the minibuffer and wrap selection in this generic. Useful for rust"
  (let ((fname (evil-surround-read-from-minibuffer "" "")))
    (cons (format "%s<" (or fname ""))
          ">")))

(setq-local evil-surround-pairs-alist (append '((?g . my-evil-surround-generic)) evil-surround-pairs-alist))
