(defun with-face (face-name str)
  (propertize str 'face face-name))

(defun get-header-line-file-content ()
  (if (projectile-project-p)
      (concat
       (with-face 'header-line-projectile (concat "[" (projectile-project-name) "] ")))
    (abbreviate-file-name buffer-file-name))
  )

(defun make-header-line ()
  (setq header-line-format
        '("" ;; invocation-name
          (:eval (let ((content (if (buffer-file-name) (get-header-line-file-content) "%b")))
                   content)))))


(add-hook 'buffer-list-update-hook
          'make-header-line)

(defface header-line-projectile `((t (:foreground "#569395" :background "#3c3836")))  "Header-Line background")

(set-face-attribute 'header-line nil
                    :background "#3c3836"
                    :foreground "#ebdbb2"
                    :weight 'bold)
