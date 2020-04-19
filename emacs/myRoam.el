(setq my-org-roam-directory "~/resource/org/myroam/")

(defun list-note-files ()
  (directory-files my-org-roam-directory nil ".*.org" )
)

(defun get-helm-source-note-files ()
  (helm-build-sync-source "Notes" :candidates (list-note-files))
)

(defun get-helm-source-create-file ()
  (helm-build-dummy-source "Create-file" :action 'identity)
)

(defun get-helm-source-find-note ()
    (list (get-helm-source-note-files) (get-helm-source-create-file))
)

(defun helm-find-note ()
  (let ((helm-query-result (helm :sources (get-helm-source-find-note))))
       (if (null helm-query-result) 'nil
       (if (file-exists-p (get-absolute-filename helm-query-result))
       (get-note-from-filename helm-query-result)
       (get-note-from-title helm-query-result))))
)

(defun do-if-helm-query-succeeded (func query-result)
  (if (null query-result)
    nil
    (funcall func query-result)))

(defun helm-find-or-create-note ()
  (do-if-helm-query-succeeded 'find-or-create-note (helm-find-note)))

(defun helm-insert-link-to-note ()
  (do-if-helm-query-succeeded 'insert-link-to-note (helm-find-note)))

(defun note-exists (note)
  (file-exists-p (get-absolute-filename-from-note note))
)
(defun find-or-create-note (note)
  (interactive)
  (ensure-note-exists note)
  (find-note note)
)

(defun ensure-note-exists (note)
  (if (not (note-exists note))
      (create-note note))
)

(defun insert-link-to-note (note)
  (interactive)
  (insert (get-link-to-note note))
)

(defun get-link-to-note (note)
  (ensure-note-exists note)
  (concat "[[" (note-title note) "][" (note-filename note) "]")
)

(defun find-note (note)
  (find-file (get-absolute-filename-from-note note))
)

(defun create-note (note)
  (insert-file-contents (note-filename note) (get-title-string note))
)

; Bookkeeping
(cl-defstruct note filename title)

(defun get-note-from-filename (filename)
  (make-note :filename filename :title (get-title-from-filename filename))
)

(defun get-note-from-title (title)
    (make-note :filename (get-filename-from-title title) :title title))

; Actual translation functions
(defun get-absolute-filename-from-note (note)
  (get-absolute-filename (note-filename note))
)

(defun get-absolute-filename (filename)
    (f-join my-org-roam-directory filename)
)

(defun get-title-from-filename (filename)
  (s-replace "_" " " (s-replace ".org" "" (s-replace-regexp "[0-9]\\{14\\}-" "" filename)))
)

; Messy functions
(defun get-title-string (note)
  (let ((title (note-title note)))
    (concat "#+TITLE: " title)))

(defun get-filename-from-title (title)
    (let ((date-string (format-time-string "%Y%m%d%H%M%S")))
    (concat date-string "-" (s-replace " " "_" title) ".org"))
)

(helm-insert-link-to-note)

