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
