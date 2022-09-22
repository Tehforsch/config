(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'lsp-mode)
;; (add-hook 'c-mode-hook '(lambda (hide-ifdef-mode nil)))
;; (add-hook 'c-mode-hook '(lambda (setq default-tab-width 4)))

(setq ccls-enable-skipped-ranges nil)

; Default C-comment: // is (objectively) much more beautiful than /*, especially for single lines 
(defun comment-c-mode-hook ()
  (setq-local comment-start "//")
  (setq-local comment-padding " ")
  (setq-local comment-end "")
  (setq-local comment-style 'indent))
(add-hook 'c-mode-hook 'comment-c-mode-hook)

