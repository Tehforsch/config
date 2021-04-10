(use-package evil-multiedit)

(define-key evil-normal-state-map (kbd "C-S-n") 'evil-multiedit-match-and-next)
(define-key evil-visual-state-map (kbd "C-S-p") 'evil-multiedit-match-and-prev)

(define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
(define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)

(define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)
