;; (general-create-definer global-leader-def
;;   :keymaps 'override
;;   :prefix "SPC")

(general-create-definer mode-leader-def
  :prefix ",")

(general-define-key
 :states '(normal visual emacs motion)
 :keymaps 'override
 :prefix "SPC"
    "!" 'start-terminal-in-pwd
    "." '((lambda () (interactive) (load-file buffer-file-name)) :which-key "Load this file")
    "x" 'execute-extended-command
    "b" '(:which-key "Buffer")
    "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :which-key "go to *Messages* buffer")
    "bf" 'switch-to-buffer
    "bF" 'projectile-switch-to-buffer
    ; When deleting or moving to next/previous buffer stay in buffer switching mode
    "bd" '((lambda () (interactive) (kill-this-buffer) (hydra-switch-buffer/body)) :which-key "Delete buffer (transient)")
    "bp" '((lambda () (interactive) (projectile-previous-project-buffer) (hydra-switch-buffer/body)) :which-key "Previous buffer (transient)")
    "bn" '((lambda () (interactive) (projectile-next-project-buffer) (hydra-switch-buffer/body)) :which-key "Next buffer (transient)")
    "bs" 'evil-save-modified-and-close
    "e" '(:which-key "Emacs")
    "eR" '((lambda () (interactive) (load-file "~/.emacs")) :which-key "Reload emacs config")
    "f" '(:which-key "File")
    "fA" '(:which-key "Autosave")
    "fAd" 'ediff-current-file
    "fAr" 'recover-this-file
    "fs" 'save-buffer
    "fo" 'projectile-find-other-file
    "ff" 'smart-list-files
    "fF" 'projectile-find-file-in-known-projects
    "fp" 'comment-out-line-and-copypaste-below
    "fq" 'evil-save-modified-and-close
    "g" '(:which-key "Magit")
    "gb" 'magit-blame
    "gl" 'magit-log-buffer-file
    "gs" 'magit-status
    "gr" '((lambda () (interactive) (magit-ediff-resolve (buffer-file-name))) :which-key "Resolve merge conflict in current file")
    "h" 'selectrum-repeat
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
    "oll" 'org-toggle-latex-fragment
    "olL" '((lambda () (interactive) (org-latex-preview 16)) :which-key "Clear all latex fragments")
    "oj" '(:which-key "Journal")
    "ojp" '(hydra-journal-personal/body :which-key "Personal")
    "ojw" '(hydra-journal-work/body :which-key "Work")
    "oL" 'org-toggle-link-display
    "on" '(:which-key "Notes")
    "ona" 'rpundit-append-link
    "onb" 'rpundit-find-backlinks
    "one" '(:which-key "Export notes")
    "onf" 'rpundit-find
    "onk" 'rpundit-get-new-anki-note-check-file-for-model-and-deck
    "ong" 'rpundit-graph-find
    "oni" 'rpundit-insert-link
    "onep" 'org-latex-export-to-pdf
    "onp" '(:which-key "Papers")
    "onpf" 'rpundit-find-paper
    "onR" 'pundit-rename-this-note
    "oti" 'capture-inbox-task
    "p" '(:which-key "Project")
    "p!" 'start-terminal-in-projectile-folder
    "pa" 'consult-ripgrep
    "pr" 'projectile-replace
    "pS" 'projectile-save-project-buffers
    "pR" 'projectile-discover-projects-in-search-path
    "pf" 'projectile-switch-project
    "r" 'save-file-and-run-last-command-in-terminal-to-the-right
    "R" 'save-file-and-run-last-command-in-terminal-to-the-right-no-switch-back
    "u" '(:which-key "Undo")
    "ut" 'undo-tree-visualize
    "w" 'save-buffer
    "W" '(:which-key "Window")
    "Wd" 'kill-buffer-and-window
    "Wh" 'evil-window-left
    "Wj" 'evil-window-down
    "Wk" 'evil-window-up
    "Wl" 'evil-window-right
    "WH" 'evil-window-move-far-left
    "WJ" 'evil-window-move-very-bottom
    "WK" 'evil-window-move-very-top
    "WL" 'evil-window-move-far-right
    "Wo" 'delete-other-windows
    "^" 'evil-switch-to-windows-last-buffer
)

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
    "en" 'next-error
    "ep" 'previous-error
    "h" 'hs-hide-all
    "s" 'hs-show-all
)

(mode-leader-def '(normal visual) 'c-mode-map
    "en" 'next-error
    "ep" 'previous-error
    "s" 'consult-lsp-workspace-all-symbols
    "x" 'helm-lsp-workspace-all-symbols
)

(mode-leader-def '(normal visual) 'fortran-mode-map
    "en" 'next-error
    "ep" 'previous-error
    "h" 'hs-hide-all
    "s" 'hs-show-all
)

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
    "r" 'erefactor-rename-symbol-in-buffer
)

(mode-leader-def '(normal visual) 'rustic-mode-map
    "d" 'rust-dbg-wrap-or-unwrap
    "el" 'consult-lsp-diagnostics
    "en" 'next-error
    "ep" 'previous-error
    "f" 'rustic-format-buffer
    "h" 'toggle-lsp-ui-sideline-show-hover
    "r" 'lsp-rename
    "p" 'lsp-rust-find-parent-module
    "s" 'helm-lsp-workspace-all-symbols
    "x" 'helm-lsp-code-actions
)


(mode-leader-def '(normal visual) 'python-mode-map
    "en" 'next-error
    "ep" 'previous-error
    "d" 'python-insert-debug-trace
    "h" 'hs-hide-all
    "s" 'hs-show-all
    "r" 'lsp-rename
)


(define-key evil-normal-state-map "gd" 'xref-find-definitions)
(define-key evil-normal-state-map "gt" 'lsp-goto-type-definition)
(setq xref-prompt-for-identifier nil)
(define-key evil-normal-state-map "gr" 'xref-find-references)
(define-key evil-normal-state-map "gh" 'lsp-ui-doc-show)
(define-key evil-normal-state-map "g^" 'beginning-of-defun)
(define-key evil-normal-state-map "g$" 'end-of-defun)


; Org-mode hotkeys
(defun add-org-mode-motion-keys ()
    (define-key evil-normal-state-map "gl" 'org-open-at-point))

(add-hook 'org-mode-hook 'add-org-mode-motion-keys)

(defun add-term-mode-motion-keys ()
    (evil-local-set-key 'insert (kbd "<escape>") 'term-kill-subjob))

(add-hook 'term-mode-hook 'add-term-mode-motion-keys)
