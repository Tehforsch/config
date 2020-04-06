(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" projectile-next-project-buffer)
    ("p" projectile-previous-project-buffer)
    ("d" kill-this-buffer)
)

(defhydra hydra-journal-switch-day ()
    "Switch days in journal"
    ("n" find-file-relative-tomorrow)
    ("p" find-file-relative-yesterday)
)
