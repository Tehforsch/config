(defun start-terminal-in-pwd ()
  (interactive)
  (start-process "kitty-process" "kitty-buffer" "kitty"))
