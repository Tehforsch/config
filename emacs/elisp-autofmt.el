(use-package elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config (setq elisp-autofmt-style 'fixed))

(setq-local lisp-indent-offset 2)
(setq-local indent-tabs-mode nil)
(setq-local lisp-indent-function nil)
(setq-local lisp-indent-offset 2)
