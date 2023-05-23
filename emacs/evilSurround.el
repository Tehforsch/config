(use-package
  evil-surround
  :config

  (global-evil-surround-mode 1)
  (add-hook 'evil-surround-mode-hook 'add-rust-surround-pairs)
  (add-hook 'rustic-mode-hook 'add-rust-surround-pairs))

(defun my-swap-surround-and-replace ()
  (interactive)
  (if (not (member major-mode evil-collection-mode-list))
      (progn
        (evil-local-set-key 'normal (kbd "s") 'evil-surround-region)
        (evil-local-set-key 'normal (kbd "S") 'evil-substitute))
    ))

(add-hook 'find-file-hook 'my-swap-surround-and-replace)

(defun add-surround-pairs ()
  (evil-add-to-alist
    'evil-surround-pairs-alist
    ?\( '("(" . ")")
    ?\) '("(" . ")")
    ?\[ '("[" . "]")
    ?\] '("[" . "]")
    ?\{ '("{" . "}")
    ?\{ '("{" . "}")
    ))

(defun add-rust-surround-pairs ()
  (evil-add-to-alist
    'evil-surround-pairs-alist
    ?& '("&" . "")
    ?r '("&" . "")
    ?* '("*" . "")
    ?g 'evil-surround-read-generic
    ?G 'evil-surround-read-appended-generic
    ?t 'evil-surround-read-turbofish))

(defun evil-surround-read-generic ()
  "Read a surrounding generic from the minibuffer"
  (let*
    (
      (input
        (evil-surround-read-from-minibuffer
          "generic: "
          ""
          evil-surround-read-tag-map)))
    (cons (format "%s<" (or input "")) ">")))

(defun evil-surround-read-appended-generic ()
  "Read an appended generic from the minibuffer"
  (let*
    (
      (input
        (evil-surround-read-from-minibuffer
          "generic: "
          ""
          evil-surround-read-tag-map)))
    (cons "" (format "<%s>" (or input "")))))

(defun evil-surround-read-turbofish ()
  "Read an appended turbofish from the minibuffer"
  (let*
    (
      (input
        (evil-surround-read-from-minibuffer
          "turbofish: "
          ""
          evil-surround-read-tag-map)))
    (cons "" (format "::<%s>" (or input "")))))
