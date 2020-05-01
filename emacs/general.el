(use-package general)
(general-evil-setup t)

(general-create-definer global-leader-def
  :prefix "SPC")

(general-create-definer mode-leader-def
  :prefix ",")

(global-leader-def '(normal visual) 'global
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
    "f" '(:which-key "File")
    "fA" '(:which-key "Autosave")
    "fAd" 'ediff-current-file
    "fAr" 'recover-this-file
    "fs" 'save-buffer-always
    "fo" 'projectile-find-other-file
    "fl" 'helm-locate
    "ff" 'smart-list-files
    "fF" 'helm-projectile-find-file-in-known-projects
    "fp" 'comment-out-line-and-copypaste-below
    "g" '(:which-key "Magit")
    "gb" 'magit-blame
    "gs" 'magit-status
    "j" '(:which-key "Jump/Bookmarks")
    "jf" 'helm-bookmarks
    "ja" 'bookmark-set-with-default-name
    "o" '(:which-key "Org")
    "oc" '(:which-key "Citations/Bibliography")
    "oca" 'crossref-add-bibtex-entry
    "oci" 'org-ref-insert-link
    "oco" 'open-bibliography
    "ocp" 'org-ref-open-pdf-at-point
    "oi" '(:which-key "Image")
    "ois" '((lambda () (interactive) (insert-screenshot "scrot -s")) :which-key "Screenshot")
    "oiS" '((lambda () (interactive) (insert-screenshot "~/projects/config/scripts/captureScreenshot.sh")) :which-key "Screenshot with white taken as transparent.")
    "oit" 'org-toggle-inline-images
    "ol" '(:which-key "Latex")
    "oll" 'org-latex-preview
    "olL" '((lambda () (interactive) (org-latex-preview 16)) :which-key "Clear all latex fragments")
    "oj" '(:which-key "Journal")
    "ojr" '((lambda () (interactive) (if (pundit-find-or-create-note-random-day) (hydra-journal-switch-day/body))) :which-key "Next day (transient).")
    "ojt" 'pundit-find-or-create-note-today
    "ojy" 'pundit-find-or-create-note-yesterday
    "ojn" '((lambda () (interactive) (if (pundit-find-or-create-note-day-after) (hydra-journal-switch-day/body))) :which-key "Next day (transient).")
    "ojp" '((lambda () (interactive) (if (pundit-find-or-create-note-day-before) (hydra-journal-switch-day/body))) :which-key "Previous day (transient).")
    "oL" 'org-toggle-link-display
    "on" '(:which-key "Notes")
    "ona" 'pundit-helm-append-link-to-note
    "onb" 'pundit-helm-find-backlinks
    "one" '(:which-key "Export notes")
    "onf" 'pundit-helm-find-or-create-note
    "oni" 'pundit-helm-insert-link-to-note
    "onep" 'org-latex-export-to-pdf
    "onp" '(:which-key "Papers")
    "onpf" 'pundit-helm-find-or-create-note-for-paper
    "onR" 'pundit-rename-this-note
    "ota" 'my-daily-agenda
    "oti" '((lambda () (interactive) (org-capture nil "i")) :which-key "Inbox task")
    "otf" '((lambda () (interactive) (find-file org-default-notes-file)) :which-key "Open todo file.")
    "p" '(:which-key "Project")
    "p!" 'projectile-run-shell
    "pa" 'helm-projectile-ag
    "pt" 'projectile-regenerate-tags
    "pr" 'projectile-replace
    "pS" 'projectile-save-project-buffers
    "pR" 'projectile-discover-projects-in-search-path
    "pf" 'helm-projectile-switch-project
    "R" '((lambda () (interactive) (load-file "~/.emacs")) :which-key "Reload emacs config")
    "w" '(:which-key "Window")
    "wd" 'kill-buffer-and-window
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wH" 'evil-window-move-far-left
    "wJ" 'evil-window-move-very-bottom
    "wK" 'evil-window-move-very-top
    "wL" 'evil-window-move-far-right
    "wo" 'delete-other-windows
    "^" 'evil-switch-to-windows-last-buffer
)

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
    "^" 'beginning-of-defun
    "$" 'end-of-defun
    "en" 'next-error
    "ep" 'previous-error
    "h" 'hs-hide-all
    "s" 'hs-show-all
)

(mode-leader-def '(normal visual) 'c-mode-map
    "^" 'beginning-of-defun
    "$" 'end-of-defun
    "en" 'next-error
    "ep" 'previous-error
    "h" 'hs-hide-all
    "s" 'hs-show-all
)

(mode-leader-def '(normal visual) 'fortran-mode-map
    "^" 'beginning-of-defun
    "$" 'end-of-defun
    "en" 'next-error
    "ep" 'previous-error
    "h" 'hs-hide-all
    "s" 'hs-show-all
)

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
    "r" 'erefactor-rename-symbol-in-buffer
)

(mode-leader-def '(normal visual) 'org-mode-map
    "" '(:which-key "Todo")
    "a" '((lambda () (interactive) (org-agenda nil "n")) :which-key "Agenda today")
    "t" 'org-set-tags-command
    "c" 'org-archive-done-tasks
    "d" '(:which-key "Set deadline")
    "r" '((lambda () (interactive) (org-refile)) :which-key "Refile")
    "df" '((lambda () (interactive) (org-deadline nil nil)) :which-key "Find day")
    "dr" '((lambda () (interactive) (org-deadline '(4))) :which-key "Remove")
    "d0" '((lambda () (interactive) (org-deadline nil "+0d")) :which-key "+0d")
    "d1" '((lambda () (interactive) (org-deadline nil "+1d")) :which-key "+1d")
    "d2" '((lambda () (interactive) (org-deadline nil "+2d")) :which-key "+2d")
    "d3" '((lambda () (interactive) (org-deadline nil "+3d")) :which-key "+3d")
    "d4" '((lambda () (interactive) (org-deadline nil "+4d")) :which-key "+4d")
    "d5" '((lambda () (interactive) (org-deadline nil "+5d")) :which-key "+5d")
    "d6" '((lambda () (interactive) (org-deadline nil "+6d")) :which-key "+6d")
    "d7" '((lambda () (interactive) (org-deadline nil "+7d")) :which-key "+7d")
    "d8" '((lambda () (interactive) (org-deadline nil "+8d")) :which-key "+8d")
    "d9" '((lambda () (interactive) (org-deadline nil "+9d")) :which-key "+9d")
    "s" '(:which-key "Set schedule")
    "sf" '((lambda () (interactive) (org-schedule nil nil)) :which-key "Find day")
    "sr" '((lambda () (interactive) (org-schedule '(4))) :which-key "Remove")
    "s0" '((lambda () (interactive) (org-schedule nil "+0d")) :which-key "+0d")
    "s1" '((lambda () (interactive) (org-schedule nil "+1d")) :which-key "+1d")
    "s2" '((lambda () (interactive) (org-schedule nil "+2d")) :which-key "+2d")
    "s3" '((lambda () (interactive) (org-schedule nil "+3d")) :which-key "+3d")
    "s4" '((lambda () (interactive) (org-schedule nil "+4d")) :which-key "+4d")
    "s5" '((lambda () (interactive) (org-schedule nil "+5d")) :which-key "+5d")
    "s6" '((lambda () (interactive) (org-schedule nil "+6d")) :which-key "+6d")
    "s7" '((lambda () (interactive) (org-schedule nil "+7d")) :which-key "+7d")
    "s8" '((lambda () (interactive) (org-schedule nil "+8d")) :which-key "+8d")
    "s9" '((lambda () (interactive) (org-schedule nil "+9d")) :which-key "+9d")
)

(mode-leader-def '(normal visual) 'pundit-mode-map
    "a" 'pundit-helm-append-link-to-note
    "b" 'pundit-helm-find-backlinks
    "e" '(:which-key "Export notes")
    "f" 'pundit-helm-find-or-create-note
    "i" 'pundit-helm-insert-link-to-note
    "ep" 'org-latex-export-to-pdf
    "p" '(:which-key "Papers")
    "pf" 'pundit-helm-find-or-create-note-for-paper)
