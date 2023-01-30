(use-package magit)

(setq evil-magit-use-y-for-yank t)

(general-define-key
  :keymaps
  'transient-base-map
  "<escape>"
  'transient-quit-one)

; Unbind space so that general leader still works.
(define-key magit-status-mode-map (kbd "SPC") nil)
(define-key magit-blame-mode-map (kbd "SPC") nil)
(define-key magit-blame-read-only-mode-map (kbd "SPC") nil)

; Make diffs prettier
(setq magit-diff-refine-hunk (quote all))
