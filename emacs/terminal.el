(defun start-terminal-in-pwd ()
  (interactive)
  (start-process "kitty-process" "kitty-buffer" "kitty"))

(defun start-terminal-in-projectile-folder ()
  (interactive)
  (let ((project-folder (projectile-project-root)))
    (message project-folder)
    (start-process "kitty-process" "kitty-buffer" "kitty" (s-concat "-d=" project-folder))))
