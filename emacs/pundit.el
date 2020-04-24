(defvar pundit-mode-map (make-sparse-keymap) "Keymap for pundit mode.")
(defvar pundit-find-note-hook nil "Hook called when a new buffer with a pundit note is opened.")
(defvar pundit-after-save-note-hook nil "Hook called when a buffer with a pundit note is saved.")
(add-hook 'pundit-after-save-note-hook #'pundit--refresh-links-for-current-note)
(defvar pundit-title-property-name "TITLE")

(define-minor-mode pundit-mode
  "Toggle Pundit mode."
  :init-value nil
  :lighter " Pundit"
  :keymap 'pundit-mode-map)

; Bookkeeping, clean functions
(cl-defstruct pundit-note filename title)

(defun pundit--get-note-from-filename (filename)
  (make-pundit-note :filename filename :title (pundit--get-title-from-filename filename)))

(defun pundit--get-note-from-title (title)
  (make-pundit-note :filename (pundit--get-filename-from-title title) :title title))

(defun pundit--get-note-from-absolute-filename (absolute-filename)
  (pundit--get-note-from-filename (file-name-nondirectory absolute-filename)))

(defun pundit--current-note ()
  (pundit--get-note-from-absolute-filename buffer-file-name))

(defun pundit--list-notes (&optional link-filter-predicate)
  (let* ((files (directory-files pundit-directory nil ".*.org" ))
        (notes (mapcar 'pundit--get-note-from-filename files)))
    (if (null link-filter-predicate)
        (remove-if-not default-link-filter-predicate notes)
        (remove-if-not link-filter-predicate notes))))

(defun pundit--list-all-notes ()
  (pundit--list-notes nil))

(defun pundit--link-to-note-predicate (linked-note truth-value)
  (lexical-let ((linked-note linked-note)
                (truth-value truth-value))
    (lambda (note) (let* ((links (pundit--get-linked-notes note))
                         (is-member (member linked-note links)))
                   (if truth-value
                       is-member
                       (not is-member))))))

(defun pundit--has-link-to-note-predicate (linked-note)
  (pundit--link-to-note-predicate linked-note t))

(defun pundit--has-no-link-to-note-predicate (linked-note)
  (pundit--link-to-note-predicate linked-note nil))

(defun pundit--note-exists (note)
  (file-exists-p (pundit--get-absolute-filename-from-note note)))

(defun pundit--find-or-create-note (note &optional text)
  (pundit--ensure-note-exists note text)
  (pundit--find-note note))

(defun pundit--ensure-note-exists (note &optional text)
  (if (not (pundit--note-exists note))
      (pundit--create-note note text)))

(defun pundit--create-link-to-note (insert-function note)
  (funcall insert-function (pundit--get-link-to-note note)))

(defun pundit--get-link-to-note (note)
  (pundit--ensure-note-exists note)
  (pundit--get-link-string (pundit-note-filename note) (pundit-note-title note)))

(defun pundit--get-link-string (filename title)
  (concat "[[file:" filename "][" title "]]"))

(defun pundit--find-note (note)
  (find-file (pundit--get-absolute-filename-from-note note))
  (run-hooks 'pundit-find-note-hook)
  (add-hook 'after-save-hook 'pundit--run-after-save-note-hook nil t)
  (add-hook 'after-save-hook 'pundit--validate-this-note nil t))

(defun pundit--run-after-save-note-hook ()
  (run-hooks 'pundit-after-save-note-hook))

(defun pundit--create-note (note &optional text)
  (let* ((title-string (pundit--get-title-string note))
        (text-string (if (null text) "" text))
        (to-insert (concat title-string "\n" text-string)))
  (with-temp-file (pundit--get-absolute-filename-from-note note) (insert to-insert))))

; Actual translation/string manipulation functions
(defun pundit--get-absolute-filename-from-note (note)
  (pundit--get-absolute-filename (pundit-note-filename note)))

(defun pundit--get-absolute-filename (filename)
  (f-join pundit-directory filename))

(defun pundit--get-title-from-filename (filename)
  (s-replace "_" " " (s-replace ".org" "" (s-replace-regexp "[0-9]\\{14\\}-" "" filename))))

(defun pundit--get-title-string (note)
  (let ((title (pundit-note-title note)))
    (concat "#+" pundit-title-property-name ": " title)))

(defun pundit--convert-title-to-last-part-of-filename (title)
    (concat (s-replace " " "_" title) ".org"))

(defun pundit--get-filename-from-title (title)
  (let*
      ((title-part-of-filename (pundit--convert-title-to-last-part-of-filename title))
       (matching-files (directory-files pundit-directory nil (concat "^[0-9]\\{14\\}-" title-part-of-filename))))
    (progn
      (assert (< (list-length matching-files) 2))
      (if (eq (list-length matching-files) 1)
          (car matching-files)
        (let ((date-string (format-time-string "%Y%m%d%H%M%S")))
          (concat date-string "-" title-part-of-filename))))))

(defun convert-filename-with-new-title (old-filename new-title)
  (let ((old-date-string (substring old-filename 0 14)))
  (concat old-date-string "-" (pundit--convert-title-to-last-part-of-filename new-title))))

; Helm/User-functions
(defun pundit--get-helm-source-notes (&optional link-filter-predicate)
  (let* ((notes (pundit--list-notes link-filter-predicate))
        (helm-formatted-notes (mapcar (lambda (note) (cons (pundit-note-title note) (pundit-note-filename note))) notes)))
    (helm-build-sync-source "Notes" :candidates helm-formatted-notes :fuzzy-match t)))

(defun pundit--get-helm-source-create-file ()
  (helm-build-dummy-source "Create-file" :action 'identity))

(defun pundit--get-helm-source-get-note (&optional link-filter-predicate)
  (list (pundit--get-helm-source-notes link-filter-predicate) (pundit--get-helm-source-create-file)))

(defun pundit--helm-get-note (&optional link-filter-predicate)
  (let ((helm-query-result (helm :sources (pundit--get-helm-source-get-note link-filter-predicate))))
    (if (null helm-query-result) 'nil
      (if (file-exists-p (pundit--get-absolute-filename helm-query-result))
          (pundit--get-note-from-filename helm-query-result)
        (pundit--get-note-from-title helm-query-result)))))

(defun pundit--do-if-helm-query-succeeded (func query-result)
  (if (null query-result)
      nil
    (funcall func query-result)))

(defun pundit-helm-find-or-create-note (&optional link-filter-predicate)
  (interactive)
  (pundit--do-if-helm-query-succeeded 'pundit--find-or-create-note (pundit--helm-get-note link-filter-predicate)))

(defun pundit--helm-create-link-to-note (insert-function &optional link-filter-predicate)
  (pundit--do-if-helm-query-succeeded (lambda (note) (pundit--create-link-to-note insert-function note)) (pundit--helm-get-note link-filter-predicate)))

(defun pundit-helm-insert-link-to-note (&optional link-filter-predicate)
  (interactive)
  (pundit--helm-create-link-to-note 'insert link-filter-predicate))

(defun pundit-helm-append-link-to-note (&optional link-filter-predicate)
  (interactive)
  (pundit--helm-create-link-to-note (lambda (text) (progn (evil-append nil nil nil) (insert text)))) link-filter-predicate)

(defun pundit--read-linked-notes-from-file (note)
  (with-temp-buffer
    (insert-file-contents (pundit--get-absolute-filename-from-note note))
    (org-element-map (org-element-parse-buffer) 'link
      (lambda (link)
        (when (string= (org-element-property :type link) "file")
          (pundit--get-note-from-filename (org-element-property :path link)))))))

(defun pundit--get-linked-notes (note &optional refresh)
  (let* ((filename (pundit-note-filename note))
         (stored-link (assoc filename stored-note-links)))
    (if (or (null stored-link) refresh)
        (let ((link (pundit--read-linked-notes-from-file note)))
          (if (and refresh (not (null stored-link)))
              (setcdr stored-link link)
              (add-to-list 'stored-note-links (cons filename link)))
          link)
      (cdr stored-link))))

(defun pundit--refresh-links-for-current-note ()
    (pundit--get-linked-notes (pundit--current-note) t))

(defun pundit-helm-find-backlinks ()
  (interactive)
  (pundit-helm-find-or-create-note (pundit--has-link-to-note-predicate (pundit--current-note))))

(defun pundit--read-in-note-files ()
  (setq stored-note-links '())
  (pundit--list-all-notes))

(defun pundit--check-link-is-correct (note filename)
  (let ((absolute-filename (pundit--get-absolute-filename filename)))
    (if (not (file-exists-p absolute-filename))
        (error (format "Invalid link in pundit note:\n%s links to %s" (pundit-note-filename note) filename)))))

(defun pundit--validate-buffer-contents (note)
  (org-element-map (org-element-parse-buffer) 'link
    (lambda (link)
      (when (string= (org-element-property :type link) "file")
        (pundit--check-link-is-correct note (org-element-property :path link))))))

(defun pundit--validate-note (note)
  (with-temp-buffer
    (insert-file-contents (pundit--get-absolute-filename-from-note note))
    (pundit--validate-buffer-contents note)))

(defun pundit--validate-this-note ()
  (pundit--validate-buffer-contents (pundit--current-note)))

(defun pundit-validate-all-notes ()
  (interactive)
  (mapcar 'pundit--validate-note (pundit--list-all-notes)))
