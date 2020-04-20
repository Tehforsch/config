(setq name-of-journal-note "journal")
(defcustom date-title-format "%Y %m %d"
  "Format string passed to `format-time-string' for getting a date file's title.")

(defun get-link-text-in-journal-note ()
  (get-link-to-note (get-note-from-title name-of-journal-note)))

; Automatically create notes for days and switch between them (going to the next or previous day or to a random day)
(defun find-file-for-time (time)
  "Create and find file for TIME."
  (let* ((title (format-time-string date-title-format time))
         (note (get-note-from-title title)))
    (find-or-create-note note (get-link-text-in-journal-note))))

(defun find-file-today ()
  "Create and find file for today."
  ; 18000 is 5 hours. If I call the today-function before 5AM I want it to refer to the (technically) previous day
  (interactive)
  (find-file-for-time (time-add -18000 (current-time))))

(defun find-file-tomorrow ()
  "Create and find the file for tomorrow."
  (interactive)
  (find-file-for-time (time-add 68400 (current-time))))

(defun find-file-yesterday ()
  "Create and find the file for yesterday."
  (interactive)
  (find-file-for-time (time-add -104400 (current-time))))

(defun find-file-relative-yesterday ()
  "Find or create the file for the day before the current journal file."
  (interactive)
  (find-file-relative -86400)
)

(defun find-file-relative-tomorrow ()
  "Find or create the file for the day after the current journal file."
  (interactive)
  (find-file-relative 86400)
)

(defun find-file-relative (time-delta)
  (if (string-match "[0-9]\\{14\\}-\\([0-9]\\{4\\}_[0-9]\\{2\\}_[0-9]\\{2\\}\\).org" buffer-file-name)
      (let* ((date-string (match-string 1 buffer-file-name))
             (time (get-time-from-isoformat-date (s-replace "_" "-" date-string))))
        (find-file-for-time (time-add time time-delta)))
))

(defun get-time-from-isoformat-date (isoformat-date)
    (org-time-convert-to-list (org-read-date nil t isoformat-date))
)

(defun find-file-date()
  "Create the file for any date using the calendar."
  (interactive)
  (let ((time (org-read-date nil 'to-time nil "Date:  ")))
    (find-file-for-time time)))

(defun random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun find-file-random-day ()
  (interactive)
  (view-file (concat (file-name-as-directory my-org-roam-directory) (random-choice (directory-files my-org-roam-directory nil "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\).org" )))))

(setq default-link-filter-predicate (has-no-link-to-note-predicate (get-note-from-title name-of-journal-note)))
