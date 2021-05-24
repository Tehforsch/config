(use-package evil-collection
  :after (evil helm)
  :custom (evil-collection-setup-minibuffer t)
  :init (progn (evil-collection-init)
               (evil-collection-ediff-setup)))
