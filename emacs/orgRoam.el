(use-package org-roam
    :hook 
    (after-init . org-roam-mode)
    :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
    :custom
    (org-roam-directory "~/resource/org/roam")
)

(defun my-org-roam-find-file-for-time (time)
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

(defun my-org-roam-today ()
  "Create and find file for today."
  (interactive)
  (my-org-roam-find-file-for-time (current-time)))

(defun my-org-roam-tomorrow ()
  "Create and find the file for tomorrow."
  (interactive)
  (my-org-roam-find-file-for-time (time-add 86400 (current-time))))

(defun my-org-roam-yesterday ()
  "Create and find the file for yesterday."
  (interactive)
  (my-org-roam-find-file-for-time (time-add -86400 (current-time))))

(defun my-org-roam-date ()
  "Create the file for any date using the calendar."
  (interactive)
  (let ((time (org-read-date nil 'to-time nil "Date:  ")))
    (my-org-roam-find-file-for-time time)))

(use-package deft
    :custom
    (deft-recursive t)
    (deft-use-filter-string-for-filename t)
    (deft-default-extension "org")
    (deft-directory org-roam-directory)
)

; Change database path
(defun org-roam--get-db ()
  "Return the sqlite db file."
  (interactive "P")
  "/home/toni/.orgRoamDb")

; Go to link under cursor
(define-key evil-normal-state-map "gl" 'org-roam-open-at-point)
