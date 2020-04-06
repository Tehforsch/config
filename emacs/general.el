(use-package general)
(general-evil-setup t)
(general-evil-define-key '(normal visual) 'global :prefix "SPC"
    "!" 'toggle-ansi-term
    "." '((lambda () (interactive) (load-file buffer-file-name)) :which-key "Load this file")
    "x" 'helm-M-x
    "b" '(:which-key "Buffer")
    "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :which-key "go to *Messages* buffer")
    "bf" 'helm-projectile-switch-to-buffer
    "bF" 'helm-buffers-list
    ; When deleting or moving to next/previous buffer stay in buffer switching mode
    "bd" '((lambda () (interactive) (kill-this-buffer) (hydra-switch-buffer/body)) :which-key "Delete buffer (transient)")
    "bp" '((lambda () (interactive) (projectile-previous-project-buffer) (hydra-switch-buffer/body)) :which-key "Previous buffer (transient)")
    "bn" '((lambda () (interactive) (projectile-next-project-buffer) (hydra-switch-buffer/body)) :which-key "Next buffer (transient)")
    "bs" 'evil-save-modified-and-close
    "c" '(:which-key "Code")
    "c^" 'beginning-of-defun
    "c$" 'end-of-defun
    "cen" 'next-error
    "cep" 'previous-error
    "ch" 'hs-hide-all
    "cs" 'hs-show-all
    "f" '(:which-key "File")
    "fs" 'save-buffer-always
    "fo" 'projectile-find-other-file
    "ff" 'smart-list-files
    "fF" 'helm-projectile-find-file-in-known-projects
    "fp" 'comment-out-line-and-copypaste-below
    "g" '(:which-key "Magit")
    "gb" 'magit-blame
    "gs" 'magit-status
    "o" '(:which-key "Org")
    "oc" '(:which-key "Citations/Bibliography")
    "oca" 'crossref-add-bibtex-entry
    "oci" 'org-ref-insert-link
    "oco" 'open-bibliography
    "ocp" 'org-ref-open-pdf-at-point
    "oi" '(:which-key "Image")
    "ois" '((lambda () (interactive) (insert-screenshot "~/projects/config/scripts/captureScreenshot.sh")) :which-key "Screenshot with white taken as transparent.")
    "oiS" '((lambda () (interactive) (insert-screenshot "scrot -s")) :which-key "Screenshot as it is.")
    "oit" 'org-toggle-inline-images
    "ol" '(:which-key "Latex")
    "oll" 'org-toggle-latex-fragment
    "oj" '(:which-key "Journal")
    "ojr" 'find-file-random-day
    "ojt" 'find-file-today
    "ojy" 'find-file-yesterday
    "ojn" '((lambda () (interactive) (if (find-file-relative-tomorrow) (hydra-journal-switch-day/body))) :which-key "Next day (transient).")
    "ojp" '((lambda () (interactive) (if (find-file-relative-yesterday) (hydra-journal-switch-day/body))) :which-key "Next day (transient).")
    "oL" 'org-toggle-link-display
    "on" '(:which-key "Notes / org-roam")
    "ona" 'org-roam-append
    "onb" 'org-roam
    "one" '(:which-key "Export notes")
    "onep" 'org-latex-export-to-pdf
    "onf" 'org-roam-find-file
    "ong" 'org-roam-show-graph
    "oni" 'org-roam-insert
    "onp" '(:which-key "Papers")
    "onpf" 'org-roam-find-file-for-paper
    "ot" '(:which-key "Todo")
    "ott" 'org-set-tags-command
    "ota" '((lambda () (interactive) (org-agenda nil "c")) :which-key "Agenda")
    "otc" 'org-archive-done-tasks
    "otf" '((lambda () (interactive) (find-file org-default-notes-file)) :which-key "Open todo file.")
    "oti" '((lambda () (interactive) (org-capture nil "i")) :which-key "Inbox task")
    "otd" '(:which-key "Set deadline")
    "otm" '((lambda () (interactive) (org-refile)) :which-key "Refile")
    "otdt" '((lambda () (interactive) (org-deadline nil "+0d")) :which-key "Now/Today")
    "otdn" '((lambda () (interactive) (org-deadline nil "+1d")) :which-key "Tomorrow (Next day)")
    "otdf" '((lambda () (interactive) (org-deadline nil nil)) :which-key "Find day")
    "otdr" '((lambda () (interactive) (org-deadline '(4))) :which-key "Remove")
    "otd0" '((lambda () (interactive) (org-deadline nil "+0d")) :which-key "Remove")
    "otd1" '((lambda () (interactive) (org-deadline nil "+1d")) :which-key "Remove")
    "otd2" '((lambda () (interactive) (org-deadline nil "+2d")) :which-key "Remove")
    "otd3" '((lambda () (interactive) (org-deadline nil "+3d")) :which-key "Remove")
    "otd4" '((lambda () (interactive) (org-deadline nil "+4d")) :which-key "Remove")
    "otd5" '((lambda () (interactive) (org-deadline nil "+5d")) :which-key "Remove")
    "otd6" '((lambda () (interactive) (org-deadline nil "+6d")) :which-key "Remove")
    "otd7" '((lambda () (interactive) (org-deadline nil "+7d")) :which-key "Remove")
    "otd8" '((lambda () (interactive) (org-deadline nil "+8d")) :which-key "Remove")
    "otd9" '((lambda () (interactive) (org-deadline nil "+9d")) :which-key "Remove")
    "ots" '(:which-key "Schedule task")
    "otst" '((lambda () (interactive) (org-schedule nil "+0d")) :which-key "Now/Today")
    "otsn" '((lambda () (interactive) (org-schedule nil "+1d")) :which-key "Tomorrow (Next day)")
    "otsf" '((lambda () (interactive) (org-schedule nil nil)) :which-key "Find day")
    "otsr" '((lambda () (interactive) (org-schedule '(4))) :which-key "Remove")
    "ots0" '((lambda () (interactive) (org-schedule nil "+0d")) :which-key "Remove")
    "ots1" '((lambda () (interactive) (org-schedule nil "+1d")) :which-key "Remove")
    "ots2" '((lambda () (interactive) (org-schedule nil "+2d")) :which-key "Remove")
    "ots3" '((lambda () (interactive) (org-schedule nil "+3d")) :which-key "Remove")
    "ots4" '((lambda () (interactive) (org-schedule nil "+4d")) :which-key "Remove")
    "ots5" '((lambda () (interactive) (org-schedule nil "+5d")) :which-key "Remove")
    "ots6" '((lambda () (interactive) (org-schedule nil "+6d")) :which-key "Remove")
    "ots7" '((lambda () (interactive) (org-schedule nil "+7d")) :which-key "Remove")
    "ots8" '((lambda () (interactive) (org-schedule nil "+8d")) :which-key "Remove")
    "ots9" '((lambda () (interactive) (org-schedule nil "+9d")) :which-key "Remove")
    "p" '(:which-key "Project")
    "p!" 'projectile-run-shell
    "pa" 'helm-projectile-ag
    "pt" 'projectile-regenerate-tags
    "pr" 'projectile-replace
    "pS" 'projectile-save-project-buffers
    "pf" 'helm-projectile-switch-project
    "R" '((lambda () (interactive) (load-file "~/.emacs")) :which-key "Reload emacs config")
    "w" '(:which-key "Window")
    "wd" 'kill-buffer-and-window
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wo" 'delete-other-windows
    "^" 'evil-switch-to-windows-last-buffer
)
