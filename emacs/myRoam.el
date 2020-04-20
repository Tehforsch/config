(setq my-org-roam-directory "~/resource/org/debugNotes/")

; Bookkeeping, clean functions
(cl-defstruct note filename title)

(defun get-note-from-filename (filename)
  (make-note :filename filename :title (get-title-from-filename filename)))

(defun get-note-from-title (title)
  (make-note :filename (get-filename-from-title title) :title title))

(defun get-note-from-absolute-filename (absolute-filename)
  (get-note-from-filename (file-name-nondirectory absolute-filename)))

(defun list-notes (&optional link-filter-predicate)
  (let* ((files (directory-files my-org-roam-directory nil ".*.org" ))
        (notes (mapcar 'get-note-from-filename files)))
    (if (null link-filter-predicate)
        (remove-if-not default-link-filter-predicate notes)
        (remove-if-not link-filter-predicate notes))))

(defun link-to-note-predicate (linked-note truth-value)
  (lexical-let ((linked-note linked-note)
                (truth-value truth-value))
    (lambda (note) (let* ((links (get-linked-notes note))
                         (is-member (member linked-note links)))
                   (if truth-value
                       is-member
                       (not is-member))))))

(defun has-link-to-note-predicate (linked-note)
  (link-to-note-predicate linked-note t))

(defun has-no-link-to-note-predicate (linked-note)
  (link-to-note-predicate linked-note nil))

(defun note-exists (note)
  (file-exists-p (get-absolute-filename-from-note note)))

(defun find-or-create-note (note &optional text)
  (ensure-note-exists note text)
  (find-note note))

(defun ensure-note-exists (note &optional text)
  (if (not (note-exists note))
      (create-note note text)))

(defun create-link-to-note (insert-function note)
  (funcall insert-function (get-link-to-note note)))

(defun get-link-to-note (note)
  (ensure-note-exists note)
  (concat "[[file:" (note-filename note) "][" (note-title note) "]]"))

(defun find-note (note)
  (find-file (get-absolute-filename-from-note note)))

(defun create-note (note &optional text)
  (let* ((title-string (get-title-string note))
        (text-string (if (null text) "" text))
        (to-insert (concat title-string "\n" text-string)))
  (with-temp-file (get-absolute-filename-from-note note) (insert to-insert))))

; Actual translation/string manipulation functions
(defun get-absolute-filename-from-note (note)
  (get-absolute-filename (note-filename note)))

(defun get-absolute-filename (filename)
  (f-join my-org-roam-directory filename))

(defun get-title-from-filename (filename)
  (s-replace "_" " " (s-replace ".org" "" (s-replace-regexp "[0-9]\\{14\\}-" "" filename))))

(defun get-title-string (note)
  (let ((title (note-title note)))
    (concat "#+TITLE: " title)))

(defun get-filename-from-title (title)
  (let*
      ((title-part-of-filename (concat (s-replace " " "_" title) ".org"))
       (matching-files (directory-files my-org-roam-directory nil (concat "^[0-9]\\{14\\}-" title-part-of-filename))))
    (progn
      (assert (< (list-length matching-files) 2))
      (if (eq (list-length matching-files) 1)
          (car matching-files)
        (let ((date-string (format-time-string "%Y%m%d%H%M%S")))
          (concat date-string "-" title-part-of-filename))))))

; Helm/User-functions

(defun get-helm-source-note-files (&optional link-filter-predicate)
  (let* ((notes (list-notes link-filter-predicate))
        (helm-formatted-notes (mapcar (lambda (note) (cons (note-title note) (note-filename note))) notes)))
    (helm-build-sync-source "Notes" :candidates helm-formatted-notes)))

(defun get-helm-source-create-file ()
  (helm-build-dummy-source "Create-file" :action 'identity))

(defun get-helm-source-find-note (&optional link-filter-predicate)
  (list (get-helm-source-note-files link-filter-predicate) (get-helm-source-create-file)))

(defun helm-get-note (&optional link-filter-predicate)
  (let ((helm-query-result (helm :sources (get-helm-source-find-note link-filter-predicate))))
    (if (null helm-query-result) 'nil
      (if (file-exists-p (get-absolute-filename helm-query-result))
          (get-note-from-filename helm-query-result)
        (get-note-from-title helm-query-result)))))

(defun do-if-helm-query-succeeded (func query-result)
  (if (null query-result)
      nil
    (funcall func query-result)))

(defun helm-find-or-create-note (&optional link-filter-predicate)
  (interactive)
  (do-if-helm-query-succeeded 'find-or-create-note (helm-get-note link-filter-predicate)))

(defun helm-create-link-to-note (insert-function &optional link-filter-predicate)
  (do-if-helm-query-succeeded (lambda (note) (create-link-to-note insert-function note)) (helm-get-note link-filter-predicate)))

(defun helm-insert-link-to-note (&optional link-filter-predicate)
  (interactive)
  (helm-create-link-to-note 'insert link-filter-predicate))

(defun helm-append-link-to-note (&optional link-filter-predicate)
  (interactive)
  (helm-create-link-to-note (lambda (text) (progn (evil-append nil nil nil) (insert text)))) link-filter-predicate)

(defun read-linked-notes (note)
  (with-temp-buffer
    (insert-file-contents (get-absolute-filename-from-note note))
    (org-element-map (org-element-parse-buffer) 'link
      (lambda (link)
        (when (string= (org-element-property :type link) "file")
          (get-note-from-filename (org-element-property :path link)))))))

(defun get-linked-notes (note)
  (let* ((filename (note-filename note))
         (stored-link (assoc filename stored-note-links)))
    (if (null stored-link)
        (let ((link (read-linked-notes note)))
          (add-to-list 'stored-note-links (cons filename link))
          link)
      (cdr stored-link))))

(defun helm-find-backlinks ()
  (interactive)
  (helm-find-or-create-note (has-link-to-note-predicate (get-note-from-absolute-filename (buffer-file-name)))))

(defun read-in-note-files ()
  (setq stored-note-links '())
  (list-notes))

; Run on startup
(if (not (boundp 'stored-note-links))
    (read-in-note-files))
