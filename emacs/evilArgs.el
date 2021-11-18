; evil-args: adds text objects for function arguments
(use-package evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)

(define-key evil-normal-state-map "gL" 'move-argument-into-next-position)
(define-key evil-normal-state-map "gH" 'move-argument-into-previous-position)

(defun move-argument-into-next-position ()
    (interactive)
    (apply #'evil-exchange (evil-inner-arg))
    (evil-forward-arg 1)
    (apply #'evil-exchange (evil-inner-arg)))

(defun move-argument-into-previous-position ()
    (interactive)
    (apply #'evil-exchange (evil-inner-arg))
    (evil-backward-arg 1)
    (apply #'evil-exchange (evil-inner-arg)))
