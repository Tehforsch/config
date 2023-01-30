(use-package
  general
  :ensure t
  :init (general-evil-setup)
  (setq general-override-states
    '(insert emacs hybrid normal visual motion operator replace)))
