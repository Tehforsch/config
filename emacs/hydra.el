(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" next-buffer)
    ("p" previous-buffer)
    ("d" kill-this-buffer)
)

(defhydra hydra-journal-switch-day ()
    "Switch days in journal"
    ("n" find-file-relative-tomorrow)
    ("p" find-file-relative-yesterday)
)
