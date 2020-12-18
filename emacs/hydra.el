(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" switch-to-next-buffer)
    ("p" switch-to-prev-buffer)
    ("d" kill-this-buffer)
)

(defhydra hydra-journal-switch-day ()
    "Switch days in journal"
    ("n" pundit-find-or-create-note-day-after)
    ("p" pundit-find-or-create-note-day-before)
    ("r" pundit-find-or-create-note-random-day)
)
