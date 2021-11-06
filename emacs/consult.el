(use-package consult)
(use-package consult-lsp)

(consult-customize
 consult-lsp-symbols
 :preview-key (kbd "C-p"))

(setq consult-project-root-function
    (lambda ()
        (when-let (project (project-current))
        (car (project-roots project)))))
;;;; 2. projectile.el (projectile-project-root)
;; (autoload 'projectile-project-root "projectile")
(setq consult-project-root-function #'projectile-project-root)
