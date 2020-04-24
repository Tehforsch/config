(defun replace-everywhere-in-buffer (old-string new-string)
  (beginning-of-buffer)
  (let ((has-old-string (search-forward old-string nil t)))
    (beginning-of-buffer)
    (while (search-forward old-string nil t)
      (replace-match new-string nil t))
    has-old-string))

(defun pundit--rename-change-title-and-file (old-filename new-filename old-title-string new-title-string)
  (let ((old-absolute-filename (pundit--get-absolute-filename old-filename))
        (new-absolute-filename (pundit--get-absolute-filename new-filename)))
    (with-temp-buffer
        (kill-matching-buffers (file-name-nondirectory old-absolute-filename) nil t)
        (insert-file-contents old-absolute-filename)
        (replace-everywhere-in-buffer old-title-string new-title-string)
        (write-file old-absolute-filename)
        ;Make sure we don't leave buffers with the old filename open
        (rename-file old-absolute-filename new-absolute-filename))))

(defun pundit--rename-update-links-for-note (old-filename new-filename old-title new-title note)
  (let ((absolute-filename (pundit--get-absolute-filename-from-note note))
        (old-link-string (pundit--get-link-string old-filename old-title))
        (new-link-string (pundit--get-link-string new-filename new-title)))
        (with-temp-buffer
          (kill-matching-buffers (file-name-nondirectory absolute-filename) nil t)
          (insert-file-contents absolute-filename)
          (let
                ; Replace strings that are completely unmodified, i.e. [[file:filename][title]]
                ; with the new title
              ((changed-exact-links (replace-everywhere-in-buffer old-link-string new-link-string))
                ; and leave all the modified link titles as they are but change their filenames
               (changed-filename-links (replace-everywhere-in-buffer old-filename new-filename)))
            (if (or changed-exact-links changed-filename-links)
                (write-file absolute-filename))))))

(defun pundit--rename-update-all-links (old-filename new-filename old-title new-title)
  (mapcar (apply-partially #'pundit--rename-update-links-for-note old-filename new-filename old-title new-title) (pundit--list-all-notes)))
  
(defun pundit--rename-note (old-note new-title) 
  (let* ((old-title (pundit-note-title old-note))
        (old-filename (pundit-note-filename old-note))
        (new-note (pundit--get-note-from-title new-title))
        (new-filename (convert-filename-with-new-title old-filename new-title))
        (old-title-string (pundit--get-title-string old-note))
        (new-title-string (pundit--get-title-string (pundit--get-note-from-title new-title))))
    (if (not (f-file-p (pundit--get-absolute-filename new-filename)))
        (progn
          (pundit--rename-change-title-and-file old-filename new-filename old-title-string new-title-string)
          (pundit--rename-update-all-links old-filename new-filename old-title new-title)
          (pundit-validate-all-notes)
          (pundit--read-in-note-files))
        (error "Cannot rename note, target file already exists: %s" new-filename))))

(defun pundit-rename-this-note ()
  (interactive)
  (let ((new-title (completing-read "New title: " nil)))
    (pundit--rename-note (pundit--current-note) new-title)
    (pundit--find-or-create-note (pundit--get-note-from-title new-title))))
