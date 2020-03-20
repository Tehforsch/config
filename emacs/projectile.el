(use-package projectile
    :config
    (setq projectile-mode 1)
    (setq projectile-project-search-path '("~/projects/"))
)

(setq projectile-mode 1)
(setq projectile-project-search-path '("~/projects/"))
(projectile-discover-projects-in-search-path)

(use-package helm-projectile
    :config
    (defvar helm-source-file-not-found
        (helm-build-dummy-source
            "Create file"
          :action 'find-file))
    (add-to-list 'helm-projectile-sources-list helm-source-file-not-found t)
)
(setq projectile-switch-project-action 'helm-projectile)
(use-package helm-etags-plus)

(defun smart-list-files ()
    "Call `helm-projectile-find-file' if in projectile project, otherwise fall back to `helm-find-files'."
    (interactive)
    (if (projectile-project-p)
        (helm-projectile-find-file)
        (helm-find-files ".")
    )
)
