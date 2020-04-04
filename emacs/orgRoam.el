(use-package org-roam
    :hook 
    (after-init . org-roam-mode)
    :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
    :custom
    (org-roam-directory "~/resource/org/roam")
)

(use-package deft
    :custom
    (deft-recursive t)
    (deft-use-filter-string-for-filename t)
    (deft-default-extension "org")
    (deft-directory org-roam-directory)
)


; Go to link under cursor
(define-key evil-normal-state-map "gl" 'org-roam-open-at-point)

(defun org-roam-append ()
  (interactive)
  (evil-append nil nil nil)
  (org-roam-insert nil)
)
