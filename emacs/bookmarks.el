(setq bookmark-save-flag t)

(defun bookmark-set-with-default-name ()
  (interactive)
  (bookmark-set (file-name-nondirectory buffer-file-name)))
