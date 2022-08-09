; Sometimes links are not recognized as org links. Update org version to deal with this
(use-package org
  :init
  ;; Install Org from ELPA if not already
  (unless (package-installed-p 'org (version-to-list "9.3"))
    (package-refresh-contents)
    (package-install (cadr (assq 'org package-archive-contents))))
  :config
)

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)

(setq bibliography-file "~/resource/papers/library.bib")
(setq bibliography-papers-folder "~/resource/papers")

(use-package reftex
            :commands turn-on-reftex
            :init
            (progn
                (setq reftex-default-bibliography '(bibliography-file))
                (setq reftex-plug-intoAUCTex t))
            )

(use-package org-ref
    :after org
    :init
    (setq reftex-default-bibliography '("~/resource/papers/library.bib"))
    (setq org-ref-default-bibliography '("~/resource/papers/library.bib"))
    (setq org-ref-pdf-directory "~/resource/papers")
    (setq bibtex-completion-bibliography bibliography-file)
    (require 'doi-utils)
    (require 'org-ref-url-utils)
    (require 'org-ref-bibtex)
    (require 'org-ref-latex)
    (require 'org-ref-arxiv)
    (require 'org-ref-pubmed)
    (require 'org-ref-isbn)
    (require 'org-ref-wos)
    (require 'org-ref-scopus)
    (setq bibtex-completion-pdf-field "file")
)

(defun open-bibliography ()
    (interactive)
    (find-file bibliography-file)
)

; Do not truncate lines in org mode
(setq org-startup-truncated nil)

; Nicer bullet points
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  
(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(insert textobjects additional calendar)))

; Make org-open-at-point open the link in the same window
(setq org-link-frame-setup (cons (cons 'file 'find-file) org-link-frame-setup))
