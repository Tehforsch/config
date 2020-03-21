(use-package org-roam
    :hook 
    (after-init . org-roam-mode)
    :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
    :custom
    (org-roam-directory "~/resource/org/roam")
)

(defun find-file-for-time (time)
  "Create and find file for TIME."
  (let* ((title (format-time-string org-roam-date-title-format time))
         (filename (format-time-string org-roam-date-filename-format time))
         (file-path (org-roam--file-path-from-id filename)))
    (if (file-exists-p file-path)
        (find-file file-path)
      (let ((org-roam-capture-templates (list (list "d" "daily" 'plain (list 'function #'org-roam--capture-get-point)
                                                    ""
                                                    :immediate-finish t
                                                    :file-name "${title}"
                                                    :head "#+TITLE: ${title}\n[[file:20200320142808-journal.org][journal]]")))
            (org-roam--capture-context 'title)
            (org-roam--capture-info (list (cons 'title title))))
        (add-hook 'org-capture-after-finalize-hook 'org-capture-goto-last-stored)
        (org-roam-capture)))))

(defun find-file-today ()
  "Create and find file for today."
  (interactive)
  (find-file-for-time (current-time)))

(defun find-file-tomorrow ()
  "Create and find the file for tomorrow."
  (interactive)
  (find-file-for-time (time-add 86400 (current-time))))

(defun find-file-yesterday ()
  "Create and find the file for yesterday."
  (interactive)
  (find-file-for-time (time-add -86400 (current-time))))

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
  (if (string-match "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\).org" buffer-file-name)
      (let* ((date-string (match-string 1 buffer-file-name))
             (time (get-time-from-isoformat-date date-string)))
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

(use-package deft
    :custom
    (deft-recursive t)
    (deft-use-filter-string-for-filename t)
    (deft-default-extension "org")
    (deft-directory org-roam-directory)
)

; Go to link under cursor
(define-key evil-normal-state-map "gl" 'org-roam-open-at-point)
