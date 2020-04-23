(use-package projectile
    :config
    (setq projectile-mode 1)
    (setq projectile-project-search-path '("~/projects/")))

(projectile-mode)
(setq projectile-project-search-path '("~/projects/"))
(projectile-discover-projects-in-search-path)

(use-package helm-projectile
    :config
    (defvar helm-source-file-not-found
        (helm-build-dummy-source
            "Create file"
          :action 'find-file))
    (add-to-list 'helm-projectile-sources-list helm-source-file-not-found t))

(setq projectile-switch-project-action 'helm-projectile)
(use-package helm-etags-plus)

(defun smart-list-files ()
    "Call `helm-projectile-find-file' if in projectile project, otherwise fall back to `helm-find-files'."
    (interactive)
    (if (projectile-project-p)
        (helm-projectile-find-file)
        (helm-find-files ".")))

;; ; Create new file if helm query for files in the project doesnt result in a file.
;; (defvar helm-source-file-not-found (helm-build-dummy-source "Create file" :action 'find-file))
;; (add-to-list 'helm-projectile-sources-list helm-source-file-not-found t)

; Make the name of the file in the status bar relative to projectile path
(defun my-proj-relative-buf-name ()
  (ignore-errors
    (rename-buffer
     (file-relative-name buffer-file-name (projectile-project-root)))))

(add-hook 'find-file-hook #'my-proj-relative-buf-name)
