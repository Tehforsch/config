(use-package magit)

(setq evil-magit-use-y-for-yank t)

(general-define-key
   :keymaps 'transient-base-map
   "<escape>" 'transient-quit-one)
