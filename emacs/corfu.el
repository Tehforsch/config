(use-package corfu
  :custom
  ;; (corfu-cycle nil)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto nil)                 
  ;; (corfu-quit-at-boundary nil)
  ;; (corfu-quit-no-match nil)
  ;; (corfu-preview-current nil)
  (corfu-popupinfo-delay 0.0)
  (corfu-popupinfo-direction '(left))
  (corfu-popupinfo-max-height 1000)
  (corfu-on-exact-match nil)
  (corfu-count 20)

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

; This is separate from corfu but part of completion, so lets put it here
(global-completion-preview-mode)
(setq completion-preview-minimum-symbol-length 1)

(set-face-attribute 'corfu-popupinfo nil :height 150)
(set-face-background 'corfu-popupinfo "gray15")

(setq corfu-map (make-sparse-keymap))

(define-key corfu-map (kbd "C-j") 'corfu-next)
(define-key corfu-map (kbd "C-k") 'corfu-previous)
(define-key corfu-map (kbd "<down>") 'corfu-next)
(define-key corfu-map (kbd "<up>") 'corfu-previous)
(define-key corfu-map (kbd "RET") 'corfu-complete)
(define-key corfu-map (kbd "C-p") 'corfu-next)
(define-key corfu-map (kbd "C-S-k") 'corfu-popupinfo-scroll-down)
(define-key corfu-map (kbd "C-S-j") 'corfu-popupinfo-scroll-up)

(define-key evil-insert-state-map (kbd "C-SPC") 'corfu-insert-separator)

(define-key global-map (kbd "C-p") 'completion-at-point)
(define-key corfu-map (kbd "C-p") 'cape-dabbrev)

(setq-local completion-styles '(orderless basic))

; For icons
	
(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default)

  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

; This hides the signature of the functions in the completion window. I'm not super happy with this, ideally i'd
; like them to be in the corfu-popupinfo doc window, but for now this is fine
;; (setq lsp-completion-show-detail nil)

;; (setq lsp-diagnostic-clean-after-change nil)
