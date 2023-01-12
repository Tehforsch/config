(use-package consult)
(use-package consult-lsp)

(consult-customize
 consult-lsp-symbols
 :preview-key (kbd "C-p"))

(setq consult-project-root-function
    (lambda ()
        (when-let (project (project-current))
        (car (project-roots project)))))

(setq consult-project-root-function #'projectile-project-root)

(setq consult-ripgrep-args "rg --color=never --path-separator / --smart-case --no-heading --line-number --line-buffered --null .")

; Make xref show xrefs and xref show definitions use completion-at-point / consult
(setq xref-show-xrefs-function 'consult-xref)
(setq xref-show-definitions-function 'consult-xref)
