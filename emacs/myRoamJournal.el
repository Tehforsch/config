(defun pundit--get-link-text-in-journal-note ()
  (pundit--get-link-to-note (pundit--get-note-from-title pundit-journal-note-name)))

; Automatically create notes for days and switch between them (going to the next or previous day or to a random day)
(defun pundit--find-or-create-note-for-time (time)
  (let* ((title (format-time-string date-title-format time))
         (note (pundit--get-note-from-title title)))
    (pundit--find-or-create-note note (pundit--get-link-text-in-journal-note))))

(defun pundit-find-or-create-note-today ()
  ; 18000 is 5 hours. If I call the today-function before 5AM I want it to refer to the (technically) previous day
  (interactive)
  (pundit--find-or-create-note-for-time (time-add -18000 (current-time))))

(defun pundit-find-or-create-note-yesterday ()
  (interactive)
  (pundit--find-or-create-note-for-time (time-add -104400 (current-time))))

(defun pundit--find-or-create-note-time-relative (time-delta)
  (if (string-match "[0-9]\\{14\\}-\\([0-9]\\{4\\}_[0-9]\\{2\\}_[0-9]\\{2\\}\\).org" buffer-file-name)
      (let* ((date-string (match-string 1 buffer-file-name))
             (time (pundit--get-time-from-isoformat-date (s-replace "_" "-" date-string))))
        (pundit--find-or-create-note-for-time (time-add time time-delta)))
))

(defun pundit-find-or-create-note-day-before ()
  "Find or create the file for the day before the current journal file."
  (interactive)
  (pundit--find-or-create-note-time-relative -86400)
)

(defun pundit-find-or-create-note-day-after ()
  "Find or create the file for the day after the current journal file."
  (interactive)
  (pundit--find-or-create-note-time-relative 86400)
)

(defun pundit--get-time-from-isoformat-date (isoformat-date)
    (org-time-convert-to-list (org-read-date nil t isoformat-date))
)

(defun pundit--random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun pundit-find-or-create-note-random-day ()
  (interactive)
  (let* ((predicate (pundit--has-link-to-note-predicate (pundit--get-note-from-title pundit-journal-note-name)))
         (journal-notes (pundit--list-notes predicate))
         (random-journal-note (pundit--random-choice journal-notes)))
    (pundit--find-or-create-note random-journal-note)))
