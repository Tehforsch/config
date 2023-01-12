(use-package corfu
  :custom
  (corfu-cycle nil)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto nil)                 ;; Enable auto completion
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match nil)
  (corfu-preview-current nil)
  (corfu-popupinfo-delay 0.0)
  (corfu-popupinfo-direction '(left))
  (corfu-echo-documentation nil)

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(set-face-attribute 'corfu-popupinfo nil :height 150)
(set-face-background 'corfu-popupinfo "gray15")

(setq corfu-map (make-sparse-keymap))

(define-key corfu-map (kbd "C-j") 'corfu-next)
(define-key corfu-map (kbd "C-k") 'corfu-previous)
(define-key corfu-map (kbd "RET") 'corfu-complete)
(define-key corfu-map (kbd "C-p") 'corfu-next)
(define-key corfu-map (kbd "C-S-k") 'corfu-popupinfo-scroll-down)
(define-key corfu-map (kbd "C-S-j") 'corfu-popupinfo-scroll-up)

(define-key evil-insert-state-map (kbd "C-SPC") 'corfu-insert-separator)

(define-key global-map (kbd "C-p") 'completion-at-point)

(setq-local completion-styles '(orderless basic))

; For icons
	
(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default)

  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))
