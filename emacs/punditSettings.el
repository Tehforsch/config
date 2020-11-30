(setq pundit-directory "~/notes")
(setq pundit-journal-note-name "journal")
(setq pundit-paper-note-name "paper")
(setq default-link-filter-predicate (pundit--has-no-link-to-note-predicate (pundit--get-note-from-title pundit-journal-note-name)))
(defcustom pundit-date-title-format "%Y %m %d"
  "Format string passed to `format-time-string' for getting a date file's title.")

(defun pundit-helm-insert-link-to-note-with-custom-title ()
  (interactive)
  (pundit-helm-insert-link-to-note nil t))

(defun pundit-helm-append-link-to-note-with-custom-title ()
  (interactive)
  (pundit-helm-append-link-to-note nil t))

; Run on startup
(if (not (boundp 'stored-note-links))
    (progn
      (pundit--read-in-note-files)
      (pundit-validate-all-notes)))

(setq rpundit/directory "~/notes")
(setq rpundit/anki-collection "~/.local/share/Anki2/realUser/collection.anki2")
(setq rpundit/executable "~/.cargo-target/release/pundit")

(setq rpundit/window-height 30)
(setq rpundit/anki-note-identifier "#")
