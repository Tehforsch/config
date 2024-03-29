(use-package
  projectile
  :config
  (setq projectile-mode 1)
  (setq projectile-project-search-path '("~/projects/")))

(projectile-mode)
(setq projectile-project-search-path '("~/projects/"))
(projectile-discover-projects-in-search-path)

(defun smart-list-files (&optional arg)
  "Call `projectile-find-file' if in projectile project, otherwise fall back to `find-file'."
  (interactive)
  (if (projectile-project-p)
    (projectile-find-file)
    (consult-fd)))

; Make the name of the file in the status bar relative to projectile path
(defun my-proj-relative-buf-name ()
  (ignore-errors
    (rename-buffer
      (file-relative-name buffer-file-name
        (projectile-project-root)))))

(add-hook 'find-file-hook #'my-proj-relative-buf-name)

(setq projectile-current-project-on-switch 'keep)

(defun open-project-alongside-terminal ()
  (projectile-switch-project)
  (start-terminal-in-projectile-folder))

(setq find-directory-functions 'smart-list-files)
