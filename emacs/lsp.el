(use-package lsp-mode
    :hook ((python-mode . lsp)
           (c-mode . lsp)
           (lsp-mode . lsp-enable-which-key-integration)))

(setq lsp-lens-enable nil)
(setq lsp-enable-symbol-highlighting nil)
(setq lsp-enable-on-type-formatting nil)
(setq lsp-modeline-code-actions-enable nil)

;; (setq lsp-auto-guess-root t) ; This disables the message when opening a new project but I'm not sure its trustworthy?

;; (use-package lsp-ui)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp))))

(use-package lsp-ui)

(setq lsp-ui-doc-enable nil
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable nil)
(setq lsp-signature-auto-activate nil)
(setq lsp-eldoc-enable-hover nil)


(setq lsp-ui-sideline-show-diagnostics nil) ; dont show diagnostics messages in sideline
(setq lsp-ui-sideline-show-hover nil) ; show hover messages in sideline
(setq lsp-ui-sideline-show-code-actions nil); show code actions in sideline
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

(setq lsp-response-timeout 2) ; Longer wait times than 2 seconds usually means it just won't respond anyways and i'd rather not wait for a long time

; the previous variant using selectrum suddenly stopped working during package upgrade and until selectrum/consult fixes their issues concerning everything lsp, i'll just use this
(use-package helm-xref)
