(use-package helm)
; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
; This is so ugly but the commented line underneath does not take precedence and im not sure how to do this otherwise.
(define-key evil-insert-state-map (kbd "C-k") 'helm-previous-line)
; (define-key helm-map (kbd "C-k") 'helm-previous-line)

(setq find-directory-functions 'helm-find-files-1)

(defun helm-xref-format-candidate-relative-path (file line summary)
  "Same as `helm-xref-format-candidate-full-path', but display path relative to projectile root."
  (let ((file (file-relative-name file (projectile-project-root))))
    (concat
     (propertize file 'font-lock-face 'helm-xref-file-name)
     (when (string= "integer" (type-of line))
       (concat
        ":"
        (propertize (int-to-string line)
		    'font-lock-face 'helm-xref-line-number)))
     ":"
     summary)))

(setq helm-xref-candidate-formatting-function 'helm-xref-format-candidate-relative-path)
