; Important for triggering inotify events: save even when not modified
(defun save-buffer-always ()
    "Save the buffer even if it is not modified."
    (interactive)
    (set-buffer-modified-p t)
    (save-buffer)
)
; Make sure save-buffer-always doesnt ruin . key state from evil. Not sure if this is actually all that important but someone mentioned it so whatever
(evil-declare-abort-repeat 'save-buffer-always)
