(use-package helm)
(use-package helm-ag)

(setq helm-completion-style 'helm-fuzzy)
(setq helm-completion-in-region-fuzzy-match t)

(setq helm-ff-transformer-show-only-basename t)

; Make C-w delete a word when instead of autocompleting in helm
(with-eval-after-load 'company (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
(with-eval-after-load 'helm (define-key helm-map (kbd "C-w") 'evil-delete-backward-word))

; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
(define-key helm-map (kbd "C-k") 'helm-previous-line)

(use-package helm-xref)
