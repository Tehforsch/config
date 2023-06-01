; Sometimes links are not recognized as org links. Update org version to deal with this
(use-package
  org
  :init
  ;; Install Org from ELPA if not already
  (unless (package-installed-p 'org (version-to-list "9.3"))
    (package-refresh-contents)
    (package-install (cadr (assq 'org package-archive-contents))))
  :config)

(use-package org-modern)
(with-eval-after-load 'org (global-org-modern-mode))

(setq org-format-latex-options
  (plist-put org-format-latex-options :scale 1.6))
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)

; Nicer bullet points
(use-package
  org-bullets
  :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package
  evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(insert textobjects additional calendar)))

; Make org-open-at-point open the link in the same window
(setq org-link-frame-setup
  (cons (cons 'file 'find-file) org-link-frame-setup))

(defun my--wrap-lines ()
  (setq truncate-lines nil))

(add-hook 'org-mode-hook 'my--wrap-lines)
