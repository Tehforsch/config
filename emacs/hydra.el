(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" switch-to-next-buffer)
    ("p" switch-to-prev-buffer)
    ("d" kill-this-buffer)
)

(defhydra hydra-journal ()
    "Switch days in journal via pundit"
    ("t" journal-today)
    ("y" journal-yesterday)
    ("a" journal-after)
    ("b" journal-day-before)
    ("n" journal-next)
    ("p" journal-previous)
)

; Just try to avoid using anonymous functions here for simplicity even though this means duplication
(defun journal-today ()
  (interactive)
  (rpundit-journal-today "journal"))

(defun journal-yesterday ()
  (interactive)
  (rpundit-journal-yesterday "journal"))

(defun journal-day-before ()
  (interactive)
  (rpundit-journal-day-before "journal"))

(defun journal-day-after ()
  (interactive)
  (rpundit-journal-day-after "journal"))

(defun journal-next ()
  (interactive)
  (rpundit-journal-next "journal"))

(defun journal-previous ()
  (interactive)
  (rpundit-journal-previous "journal"))
