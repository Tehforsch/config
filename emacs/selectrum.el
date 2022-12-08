(use-package selectrum)
(selectrum-mode +1)

(use-package selectrum-prescient)
;; to make sorting and filtering more intelligent
(selectrum-prescient-mode +1)

(evil-define-key '(normal insert) selectrum-minibuffer-map (kbd "C-j") 'selectrum-next-candidate)
(evil-define-key '(normal insert) selectrum-minibuffer-map (kbd "C-k") 'selectrum-previous-candidate)

(setq selectrum-max-window-height 20)
