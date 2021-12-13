(use-package helm)
; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
; This is so ugly but the commented line underneath does not take precedence and im not sure how to do this otherwise.
(define-key evil-insert-state-map (kbd "C-k") 'helm-previous-line)
; (define-key helm-map (kbd "C-k") 'helm-previous-line)

(setq find-directory-functions 'helm-find-files-1)
