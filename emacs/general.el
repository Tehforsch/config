(use-package general)
(general-evil-setup t)
(general-evil-define-key '(normal visual) 'global :prefix "SPC"
    "!" 'toggle-ansi-term
    "x" 'helm-M-x
    "b" '(:which-key "Buffer")
    "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :which-key "go to *Messages* buffer")
    "bf" 'helm-buffers-list
    ; When deleting or moving to next/previous buffer stay in buffer switching mode
    "bd" '((lambda () (interactive) (kill-this-buffer) (hydra-switch-buffer/body)) :which-key "Delete buffer (transient)")
    "bp" '((lambda () (interactive) (previous-buffer) (hydra-switch-buffer/body)) :which-key "Previous buffer (transient)")
    "bn" '((lambda () (interactive) (next-buffer) (hydra-switch-buffer/body)) :which-key "Next buffer (transient)")
    "c" '(:which-key "Code")
    "c^" 'beginning-of-defun
    "c$" 'end-of-defun
    "cen" 'next-error
    "cep" 'previous-error
    "f" '(:which-key "File")
    "fs" 'save-buffer-always
    "fo" 'projectile-find-other-file
    "ff" 'smart-list-files
    "fF" 'helm-projectile-find-file-in-known-projects
    "fp" 'comment-out-line-and-copypaste-below
    "o" '(:which-key "Org")
    "oc" '(:which-key "Citations/Bibliography")
    "oca" 'crossref-add-bibtex-entry
    "oci" 'org-ref-insert-link
    "oco" 'open-bibliography
    "ol" '(:which-key "Latex")
    "oll" 'org-toggle-latex-fragment
    "on" '(:which-key "Notes / org-roam")
    "onb" 'org-roam
    "onf" 'org-roam-find-file
    "oni" 'org-roam-insert
    "onp" 'interleave-mode
    "onj" '(:which-key "Journal")
    "onjt" 'my-org-roam-today
    "onjy" 'my-org-roam-yesterday
    "onjd" 'my-org-roam-date
    "ot" '(:which-key "Todo")
    "ota" 'org-agenda
    "p" '(:which-key "Project")
    "p!" 'projectile-run-shell
    "pa" 'helm-projectile-ag
    "pt" 'projectile-regenerate-tags
    "pr" 'projectile-replace
    "pS" 'projectile-save-project-buffers
    "pf" 'helm-projectile-switch-project
    "R" '((lambda () (interactive) (load-file "~/.emacs")) :which-key "Reload emacs config")
    "t" '(:which-key "Todo")
    "w" '(:which-key "Window")
    "wd" 'kill-buffer-and-window
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wo" 'delete-other-windows
    "^" 'evil-switch-to-windows-last-buffer
)