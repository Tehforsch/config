(use-package hydra)
(defhydra hydra-switch-buffer ()
    "Switch buffer"
    ("n" next-buffer)
    ("p" previous-buffer)
    ("d" kill-this-buffer)
)
