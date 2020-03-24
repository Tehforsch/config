(setq pic-folder "~/resource/org/roam/pics/")

(defvar insert-screenshot/redisplay-images t
  "Redisplay images after inserting a screenshot with
`insert-screenshot'?")

(defun insert-screenshot ()
  "Capture a screenshot and insert a link to it in the current
buffer. If `insert-screenshot/redisplay-images' is non-nil,
redisplay images in the current buffer.

By default saves images to $PIC_FOLDER/screen_%Y%m%d_%H%M%S.png,
creating the resources directory if necessary.

With a prefix arg (C-u) prompt for a filename instead of using the default.

Depends upon `import` from ImageMagick."
  (interactive)
  (unless (file-directory-p pic-folder)
    (make-directory pic-folder))
  (let* ((dest
           (format-time-string (concat pic-folder "screen_%Y%m%d_%H%M%S.png")))
         )
    ;; (call-process "scrot" nil "/usr/bin/scrot" "-s" dest)
    (shell-command (concat "scrot -s " dest))
    (message pic-folder)
    (message dest)
    (org-insert-link t (concat "file:" dest) "")
    (when insert-screenshot/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))


(defvar edit-image/redisplay-images t
  "Redisplay images after editing an image with `edit-image'?")

(defun edit-image (&optional arg)
  "Edit the image linked at point. If
`insert-screenshot/redisplay-images' is non-nil, redisplay
images in the current buffer."
  (interactive)
  (let ((img (link-file-path-at-point)))
    (start-process "gimp" nil "/usr/bin/gimp" img)
    (read-char "Editing image... Press any key when done.")
    (when edit-image/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))

(defun resize-image-at-point (&optional arg)
  "Resize the image linked at point. If
`insert-screenshot/redisplay-images' is non-nil, redisplay
images in the current buffer."
  (interactive)
  (let ((img (link-file-path-at-point))
        (percent (read-number "Resize to what percentage of current size? ")))
    (start-process "mogrify" nil "/usr/bin/mogrify"
                   "-resize"
                   (format "%s%%" percent)
                   img)
    (when edit-image/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))
