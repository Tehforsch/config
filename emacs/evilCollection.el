(use-package evil-collection
  :after (evil helm)
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init))

(evil-collection-ediff-setup)
