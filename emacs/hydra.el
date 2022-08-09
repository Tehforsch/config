(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" switch-to-next-buffer)
    ("p" switch-to-prev-buffer)
    ("k" centaur-tabs-backward)
    ("j" centaur-tabs-forward)
    ("h" centaur-tabs-backward-group)
    ("l" centaur-tabs-forward-group)
    ("d" kill-this-buffer)
    ("D" centaur-tabs-kill-other-buffers-in-current-group)
    ("J" centaur-tabs-select-end-tab)
    ("K" centaur-tabs-select-beg-tab)
)

(defhydra hydra-journal-personal ()
    "Switch days in journal via pundit"
    ("t" journal-personal-today)
    ("y" journal-personal-yesterday)
    ("a" journal-personal-day-after)
    ("b" journal-personal-day-before)
    ("n" journal-personal-next)
    ("p" journal-personal-previous)
)

(defhydra hydra-journal-work ()
    "Switch days in journal via pundit"
    ("t" journal-work-today)
    ("y" journal-work-yesterday)
    ("a" journal-work-after)
    ("b" journal-work-day-before)
    ("n" journal-work-next)
    ("p" journal-work-previous)
)
; Just try to avoid using anonymous functions here for simplicity even though this means duplication
(defun journal-personal-today ()
  (interactive)
  (rpundit-journal-today "journal"))

(defun journal-personal-yesterday ()
  (interactive)
  (rpundit-journal-yesterday "journal"))

(defun journal-personal-day-before ()
  (interactive)
  (rpundit-journal-day-before "journal"))

(defun journal-personal-day-after ()
  (interactive)
  (rpundit-journal-day-after "journal"))

(defun journal-personal-next ()
  (interactive)
  (rpundit-journal-next "journal"))

(defun journal-personal-previous ()
  (interactive)
  (rpundit-journal-previous "journal"))

(defun journal-work-today ()
  (interactive)
  (rpundit-journal-today "work"))

(defun journal-work-yesterday ()
  (interactive)
  (rpundit-journal-yesterday "work"))

(defun journal-work-day-before ()
  (interactive)
  (rpundit-journal-day-before "work"))

(defun journal-work-day-after ()
  (interactive)
  (rpundit-journal-day-after "work"))

(defun journal-work-next ()
  (interactive)
  (rpundit-journal-next "work"))

(defun journal-work-previous ()
  (interactive)
  (rpundit-journal-previous "work"))
