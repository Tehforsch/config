(use-package expand-region)

(define-key evil-normal-state-map (kbd "C-j") 'er/expand-region)
(define-key evil-normal-state-map (kbd "C-k") 'er/contract-region)
