(use-package treemacs)

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

; Always follow the currently open project
(treemacs-project-follow-mode)
(setq treemacs-project-follow-cleanup t)

(defun treemacs-toggle-only-current-project ()
  "Toggle treemacs in the current project exclusively"
  (interactive)
  (let
    ((visible  (treemacs-current-visibility)))
    (if (eq visible 'visible)
        (treemacs)
        (treemacs-display-current-project-exclusively))))
