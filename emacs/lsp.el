(use-package
  lsp-mode
  :hook
  ((python-mode . lsp)
    (c-mode . lsp)
    (lsp-mode . lsp-enable-which-key-integration))
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf
      (alist-get
        'styles
        (alist-get 'lsp-capf completion-category-defaults))
      '(orderless))))

(setq lsp-lens-enable nil)
(setq lsp-enable-symbol-highlighting nil)
(setq lsp-enable-on-type-formatting nil)
(setq lsp-modeline-code-actions-enable nil)
(setq lsp-modeline-diagnostics-enable nil)

;; (setq lsp-auto-guess-root t) ; This disables the message when opening a new project but I'm not sure its trustworthy?

;; (use-package lsp-ui)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp))))

(use-package lsp-ui)

(setq
  lsp-ui-doc-enable nil
  lsp-ui-peek-enable t
  lsp-ui-sideline-enable t
  lsp-ui-imenu-enable t
  lsp-ui-flycheck-enable nil
  lsp-ui-doc-max-height 30)
(setq lsp-signature-auto-activate nil)
(setq lsp-eldoc-enable-hover nil)


(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover nil) ; show hover messages in sideline
(setq lsp-ui-sideline-show-code-actions nil) ; show code actions in sideline
(setq lsp-ui-sideline-delay 0)


(defun toggle-lsp-ui-sideline-show-hover ()
  (interactive)
  (if lsp-ui-sideline-show-hover
    (progn
      (setq lsp-ui-sideline-show-hover nil)
      (message "Show hover OFF"))
    (progn
      (setq lsp-ui-sideline-show-hover t)
      (message "Show hover ON"))))

(defun toggle-lsp-ui-sideline-show-diagnostics ()
  (interactive)
  (if lsp-ui-sideline-show-diagnostics
    (progn
      (setq lsp-ui-sideline-show-diagnostics nil)
      (message "Show diagnostics OFF"))
    (progn
      (setq lsp-ui-sideline-show-diagnostics t)
      (message "Show diagnostics ON"))))

(setq lsp-response-timeout 15) ; Longer wait times than 4 seconds usually means it just won't respond anyways and i'd rather not wait for a long time

(setq lsp-headerline-breadcrumb-enable nil)

; Emacs-side performance improvements
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

; Save files after rename actions
(add-hook
  'lsp-after-apply-edits-hook
  (lambda (operation)
    (when (eq operation 'rename)
      (save-buffer))))

(setq lsp-completion-provider :none)

(defun corfu-lsp-setup ()
  (interactive)
  (setq-local
    completion-styles '(orderless partial-completion basic)
    completion-category-defaults nil
    completion-at-point-functions '(lsp-completion-at-point corfu-dabbrev)))

(add-hook 'lsp-completion-mode-hook #'corfu-lsp-setup)

(setq lsp-enable-snippet nil)
