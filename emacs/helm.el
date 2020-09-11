(use-package helm)
(use-package helm-ag)

;; (setq helm-ag-fuzzy-match t)

;; (setq helm-completion-style 'helm-fuzzy)
(setq helm-completion-in-region-fuzzy-match t)

;; Once we change to emacs 27 this needs to be
(setq completion-styles '(flex))

(setq helm-ff-transformer-show-only-basename t)

; Make C-w delete a word when instead of autocompleting in helm
(with-eval-after-load 'company (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
(with-eval-after-load 'helm (define-key helm-map (kbd "C-w") 'evil-delete-backward-word))

; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
(define-key helm-map (kbd "C-k") 'helm-previous-line)

; Rebind c-h a to helm apropos which is much nicer than apropos
(define-key global-map (kbd "C-h a") 'helm-apropos)

(use-package helm-xref)

(use-package helm-fd)

(setq find-directory-functions 'helm-find-files-1)
