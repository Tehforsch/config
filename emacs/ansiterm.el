(defun toggle-ansi-term ()
  "Open an ansi-term if it doesn't already exist, otherwise switch to current one. If current buffer is ansi-term, close buffer"
  (interactive)
  (if (not buffer-file-name) (kill-buffer-and-window) (
    progn
    (split-window-sensibly)
    (other-window 1)
    (if (get-buffer "*ansi-term*")
        (progn
            (switch-to-buffer-other-window "*ansi-term*")
            (evil-insert-state))
        (progn
            (ansi-term "/bin/zsh")
            (evil-insert-state)))))
)

; Stop query 'running process" on ansi-term exit
(defun set-no-process-query-on-exit ()
  (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
      (set-process-query-on-exit-flag proc nil))))

(add-hook 'term-exec-hook 'set-no-process-query-on-exit)
