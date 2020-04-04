(use-package helm)
(use-package helm-ag)
(use-package helm-flx)
(setq helm-M-x-fuzzy-match                  t
      helm-bookmark-show-location           t
      helm-buffers-fuzzy-matching           t
      helm-completion-in-region-fuzzy-match t
      helm-file-cache-fuzzy-match           t
      helm-imenu-fuzzy-match                t
      helm-mode-fuzzy-match                 t
      helm-locate-fuzzy-match               t 
      helm-quick-update                     t
      helm-recentf-fuzzy-match              t
      helm-semantic-fuzzy-match             t)

(setq helm-ff-transformer-show-only-basename t)

(use-package helm-fuzzier)
(helm-fuzzier-mode 1)
(helm-flx-mode +1)

; Make C-w delete a word when instead of autocompleting in helm
(with-eval-after-load 'company (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
(with-eval-after-load 'helm (define-key helm-map (kbd "C-w") 'evil-delete-backward-word))
; Make C-j and C-k go down/up in helm
(define-key helm-map (kbd "C-j") 'helm-next-line)
(define-key helm-map (kbd "C-k") 'helm-previous-line)
