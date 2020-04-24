(setq bookmark-save-flag t)

(defun bookmark-set-with-default-name ()
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
        (line-number (number-to-string (line-number-at-pos)))
        (function-name (which-function))
        (function-string (if (null function-name) "" (concat ":" function-name))))
    (bookmark-set (concat  filename ":" line-number function-string))))
