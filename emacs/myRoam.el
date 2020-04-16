(setq my-org-roam-directory "~/resource/org/myroam/")

(defun list-note-files ()
  (directory-files my-org-roam-directory nil ".*.org" )
)

(defun get-helm-source-note-files ()
  (helm-build-sync-source "Notes" :candidates (list-note-files))
)

(defun helm-find-note ()
  (let ((helm-query-result (helm :sources (get-helm-source-note-files))))
       (if (file-exists-p helm-query-result)
       (get-note-from-filename helm-query-result)
       (get-note-from-title helm-query-result)))
)

(defun note-exists (note)
  (file-exists-p (get-absolute-filename-from-note note))
)

(defun find-or-create-note (note)
  (if (not (note-exists note))
      (create-note note))
)

(defun create-note (note)
  (find-file (get-absolute-filename-from-note note))
  (insert (get-title-string note))
)

(defun get-title-string (note)
  (let ((title (get-title-from-note note)))
    (concat "#+TITLE: " title)))

; Note "struct": (filename title)

(defun get-filename-from-note (note)
  (car note)
)

(defun get-absolute-filename-from-note (note)
  (f-join my-org-roam-directory (get-filename-from-note note))
)

(defun get-note-from-filename (filename)
  (cons filename (get-title-from-filename filename))
)

(defun get-note-from-title (title)
  (cons (get-filename-from-title title) title)
)

(defun get-title-from-note (note)
  (cdr note)
)

; Actual translation functions
(defun get-title-from-filename (filename)
  (s-replace "_" " " (s-replace ".org" "" (s-replace-regexp "[0-9]\\{14\\}-" "" filename)))
)

(defun get-filename-from-title (title)
    (let ((date-string ) (format-time-string "%Y%m%d%H%M%S"))
    (concat date-string "-" (s-replace " " "_" filename) ".org"))
)

(message (find-or-create-note (helm-find-note)))
;; (message (get-title-from-filename (get-filename-from-note (helm-find-note))))
