(use-package corfu
  :custom
  (corfu-cycle nil)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-preview-current nil)

  :init
  (global-corfu-mode))

(setq corfu-map (make-sparse-keymap))
(define-key corfu-map (kbd "C-j") 'corfu-next)
(define-key corfu-map (kbd "C-k") 'corfu-previous)
(define-key corfu-map (kbd "RET") 'corfu-complete)
(define-key corfu-map (kbd "C-p") 'corfu-next)

(define-key evil-insert-state-map (kbd "C-SPC") 'corfu-insert-separator)

(define-key evil-normal-state-map (kbd "C-p") 'completion-at-point)

;; Aggressive completion, cheap prefix filtering.
(setq-local corfu-auto t
            corfu-auto-delay 0
            corfu-auto-prefix 0
            completion-styles '(orderless basic))
