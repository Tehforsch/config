(general-define-key
    :states '(normal visual emacs motion)
    :keymaps 'override
    :prefix "SPC"
    "!" 'start-terminal-in-pwd
    "." 'eval-buffer
    "x" 'execute-extended-command
    "k" '((lambda () (interactive) (tabbar-backward-tab) (toggle-transient-buffer)) :which-key "Previous tab")
    "j" '((lambda () (interactive) (tabbar-forward-tab) (toggle-transient-buffer)) :which-key "Next tab")
    "K" '((lambda () (interactive) (tabbar-backward-group) (toggle-transient-buffer)) :which-key "Previous tab group")
    "J" '((lambda () (interactive) (tabbar-forward-group) (toggle-transient-buffer)) :which-key "Next tab group")
    "b" 'toggle-transient-buffer
    "c" '(:which-key "Consult")
    "cm" 'consult-kmacro
    "cM" 'consult-global-mark
    "cp" 'consult-yank-from-kill-ring
    "e" '(:which-key "Emacs")
    "eR" '((lambda () (interactive) (load-file "~/projects/config/emacs/init.el")) :which-key "Reload emacs config")
    "f" '(:which-key "File")
    "fA" '(:which-key "Autosave")
    "fAd" 'ediff-current-file
    "fAr" 'recover-this-file
    "fb" 'consult-project-buffer
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
    "oL" 'org-toggle-link-display
    "p" '(:which-key "Project")
    "p!" 'start-terminal-in-projectile-folder
    "pa" 'consult-ripgrep
    "pr" 'projectile-replace
    "pS" 'projectile-save-project-buffers
    "pR" 'projectile-discover-projects-in-search-path
    "pf" 'projectile-switch-project
    "r" 'save-file-and-run-last-command-in-terminal-to-the-right
    "R" 'save-file-and-run-last-command-in-terminal-to-the-right-no-switch-back
    "s" 'save-buffer
    "u" '(:which-key "Undo")
    "ut" 'undo-tree-visualize
    "w" 'toggle-transient-window
    "^" 'evil-switch-to-windows-last-buffer
)

(general-create-definer mode-leader-def :prefix ",")

(mode-leader-def '(normal visual) 'global-map
  "e" 'toggle-transient-error
  "s" 'consult-lsp-file-symbols
  "S" 'consult-lsp-symbols
  "r" 'lsp-rename
  "x" 'lsp-execute-code-action
  "a" 'consult-line
  "A" 'consult-line-multi
  "f" 'evil-toggle-fold
  "O" 'evil-open-folds
  "C" 'evil-open-folds
  )

(mode-leader-def '(normal visual) 'emacs-lisp-mode-map
  "r" 'erefactor-rename-symbol-in-buffer
  "f" 'elisp-autofmt-buffer)

(mode-leader-def '(normal visual) 'rustic-mode-map
  "p" 'lsp-rust-find-parent-module
  "f" 'rustic-format-buffer)

(mode-leader-def '(normal visual) 'python-mode-map
  "f" 'python-black-buffer)

(mode-leader-def '(normal visual) 'nix-mode-map
  "f" 'nix-mode-format)



(define-key evil-normal-state-map "gd" 'xref-find-definitions)
(define-key evil-normal-state-map "gD" 'xref-find-definitions-other-frame)
(define-key evil-normal-state-map "gp" 'lsp-goto-implementation)
(define-key evil-normal-state-map "gt" 'lsp-goto-type-definition)
(setq xref-prompt-for-identifier nil)
(define-key evil-normal-state-map "gr" 'xref-find-references)
(define-key evil-normal-state-map "gh" 'lsp-ui-doc-show)
(define-key evil-normal-state-map "g^" 'beginning-of-defun)
(define-key evil-normal-state-map "g$" 'end-of-defun)

(define-key global-map (kbd "C-<return>") 'make-frame)

(define-key evil-normal-state-map ",t" 'evil-toggle-fold)
(define-key evil-normal-state-map ",O" 'evil-open-folds)
(define-key evil-normal-state-map ",C" 'evil-close-folds)
(define-key evil-normal-state-map ",d" 'lsp-rust-analyzer-open-external-docs)

; Org-mode hotkeys
(defun add-org-mode-motion-keys ()
  (define-key evil-normal-state-map "gl" 'org-open-at-point))

(add-hook 'org-mode-hook 'add-org-mode-motion-keys)

(defun add-term-mode-motion-keys ()
  (evil-local-set-key 'insert (kbd "<escape>") 'term-kill-subjob))

(add-hook 'term-mode-hook 'add-term-mode-motion-keys)

(general-add-hook 'after-init-hook
                    (lambda (&rest _)
                      (when-let ((messages-buffer (get-buffer "*Messages*")))
                        (with-current-buffer messages-buffer
                          (evil-normalize-keymaps))))
                    nil
                    nil
                    t)
