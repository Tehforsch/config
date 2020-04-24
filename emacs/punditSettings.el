(setq pundit-directory "~/resource/org/debugNotes/")
(setq pundit-journal-note-name "journal")
(setq pundit-paper-note-name "paper")
(setq default-link-filter-predicate (pundit--has-no-link-to-note-predicate (pundit--get-note-from-title pundit-journal-note-name)))
(defcustom pundit-date-title-format "%Y %m %d"
  "Format string passed to `format-time-string' for getting a date file's title.")

; Run on startup
(if (not (boundp 'stored-note-links))
    (progn
      (pundit--read-in-note-files)
      (pundit-validate-all-notes)))
