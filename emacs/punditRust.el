(setq rpundit-directory "~/projects/pundit/test2")

(defun get-shell-command-output (command)
  (shell-command-to-string command))

(defun get-pundit-command-lines (command)
  (let ((output (get-shell-command-output (s-concat "pundit " rpundit-directory command))))
    (split-string output "\n")))

(defun pundit-helm-find-file ()
  (let ((title (pundit-helm "list")))
    (get-pundit-command-lines (s-concat "touch " title))))

(defun pundit-helm (pundit-command)
  (let ((output-lines (get-pundit-command-lines pundit-command)))
    (helm :sources (helm-build-sync-source "Notes" :candidates output-lines :fuzzy-match t))))

;; (pundit-helm-find-file)
