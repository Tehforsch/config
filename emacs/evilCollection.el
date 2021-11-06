(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :init (progn (evil-collection-init)
               (evil-collection-ediff-setup)))
