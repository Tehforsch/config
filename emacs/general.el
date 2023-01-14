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
    "." 'eval-buffer
    "x" 'execute-extended-command
    "k" '((lambda () (interactive) (my-centaur-tabs-backward) (toggle-transient-buffer)) :which-key "Previous tab")
    "j" '((lambda () (interactive) (my-centaur-tabs-forward) (toggle-transient-buffer)) :which-key "Next tab")
    "K" '((lambda () (interactive) (my-centaur-tabs-backward-group) (toggle-transient-buffer)) :which-key "Previous tab group")
    "J" '((lambda () (interactive) (my-centaur-tabs-forward-group) (toggle-transient-buffer)) :which-key "Next tab group")
    "b" 'toggle-transient-buffer
    "e" '(:which-key "Emacs")
    "eR" '((lambda () (interactive) (load-file "~/projects/config/emacs/emacs.el")) :which-key "Reload emacs config")
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
    "gf" 'magit-find-file
    "gl" 'magit-log-buffer-file
    "gs" 'magit-status
    "gr" '((lambda () (interactive) (magit-ediff-resolve (buffer-file-name))) :which-key "Resolve merge conflict in current file")
    "h" 'vertico-repeat
    "H" 'vertico-repeat-select
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
    "ojp" 'toggle-transient-journal-map-personal
    "ojw" 'toggle-transient-journal-map-work
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
    "^" 'evil-switch-to-windows-last-buffer
)

(defun make-frame-delete-window ()
  (interactive)
 (make-frame)
 (delete-window))

(mode-leader-def '(normal visual) 'global-map
    "en" 'next-error
    "ep" 'previous-error
    "el" 'consult-lsp-diagnostics
    "s" 'consult-lsp-symbols
    "S" 'consult-lsp-file-symbols
    "f" 'rustic-format-buffer
    "r" 'lsp-rename
    "x" 'lsp-execute-code-action
    "a" 'consult-line
    "A" 'consult-line-multi
    "i" 'consult-imenu-multi
)

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
    "r" 'erefactor-rename-symbol-in-buffer
)

(mode-leader-def '(normal visual) 'rustic-mode-map
    "d" 'rust-dbg-wrap-or-unwrap
    "p" 'lsp-rust-find-parent-module
    "g" 'insert-generic-after-symbol
)


(define-key evil-normal-state-map (kbd "C-w") #'toggle-transient-window)

(define-key evil-normal-state-map "gd" 'xref-find-definitions)
(define-key evil-normal-state-map "gp" 'lsp-goto-implementation)
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
