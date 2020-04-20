(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" projectile-next-project-buffer)
    ("p" projectile-previous-project-buffer)
    ("d" kill-this-buffer)
)

(defhydra hydra-journal-switch-day ()
    "Switch days in journal"
    ("n" pundit-find-or-create-note-day-after)
    ("p" pundit-find-or-create-note-day-before)
    ("r" pundit-find-or-create-note-random-day)
)
