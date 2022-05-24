(use-package better-jumper)
(better-jumper-mode +1)

(setq better-jumper-use-evil-jump-advice t)
(setq better-jumper-context 'window)
(setq better-jumper-add-jump-behavior 'append)

(add-hook 'find-file-hook 'better-jumper-set-jump)

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "TAB") 'better-jumper-jump-forward))

; Don't add paragraph motions to jump list because I use them to move around casually
(evil-remove-command-properties #'evil-forward-paragraph :jump)
(evil-remove-command-properties #'evil-backward-paragraph :jump)
