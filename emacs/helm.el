(use-package helm)
(use-package helm-ag)

(setq helm-completion-in-region-fuzzy-match t)
(setq completion-styles '(flex))
(setq helm-ff-transformer-show-only-basename t)

; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
; This is so ugly but the commented line underneath does not take precedence and im not sure how to do this otherwise.
(define-key evil-insert-state-map (kbd "C-k") 'helm-previous-line)
;; (define-key helm-map (kbd "C-k") 'helm-previous-line)

; Rebind c-h a to helm apropos which is much nicer than apropos
(define-key global-map (kbd "C-h a") 'helm-apropos)

(use-package helm-xref)

(setq find-directory-functions 'helm-find-files-1)
