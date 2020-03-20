; Always follow symlinks without asking
(setq vc-follow-symlinks t)

; When opening symlink file: Find filetype from symlink (see https://emacs.stackexchange.com/questions/34756/emacs-linked-to-emacs-link-open-emacs-link-in-emacs-lisp-mode)
(defun zil/link-file-open-hook ()
    "for link files' major-mode in dot-file"
    (let* ((bn (buffer-file-name))
    (dot-name (concat "." (file-name-base bn)))
    (mode (assoc-default dot-name auto-mode-alist 'string-match)))
    (if (and (string= "link" (file-name-extension bn)))
    (string-match-p "dot" bn))
    (and mode (set-auto-mode-0 mode t))))

    (add-hook 'find-file-hook 'zil/link-file-open-hook)
