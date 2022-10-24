; Increase / decrease with C-a, C-x
(use-package evil-numbers)

(global-set-key (kbd "C-a") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-u") 'evil-numbers/dec-at-pt)

(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-visual-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)
(define-key evil-visual-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)
