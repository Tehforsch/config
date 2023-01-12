(use-package vertico
  :init (vertico-mode)
  (setq vertico-count 20)
  )

(use-package savehist
  :init
  (savehist-mode))

(use-package emacs
  :init
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))


; Emacs 28: Hide commands in M-x which do not work in the current mode.
; Vertico commands are hidden in normal buffers.
(setq read-extended-command-predicate
    #'command-completion-default-include-p)

(define-key vertico-map (kbd "C-j") 'vertico-next)
(define-key vertico-map (kbd "C-k") 'vertico-previous)

;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
