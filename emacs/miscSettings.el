; Don't ask when opening large files
(setq large-file-warning-threshold nil)

; Don't loop over buffers that are not associated with a file
(set-frame-parameter nil 'buffer-predicate #'buffer-file-name)
