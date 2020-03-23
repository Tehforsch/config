; Sometimes links are not recognized as org links. Update org version to deal with this
(use-package org
  :init
  ;; Install Org from ELPA if not already
  (unless (package-installed-p 'org (version-to-list "9.3"))
    (package-refresh-contents)
    (package-install (cadr (assq 'org package-archive-contents)))))

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
(setq org-startup-with-latex-preview t)

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
    (setq reftex-default-bibliography '("~/resource/org/bibliography/library.bib"))
    (setq org-ref-default-bibliography '("~/resource/org/bibliography/library.bib"))
    (setq org-ref-pdf-directory "~/resource/papers")
    (setq bibtex-completion-bibliography bibliography-file)
    (require 'doi-utils)
    (require 'org-ref-pdf)
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

;; ; Location of todolist/agenda
;; (setq org-agenda-files '("~/resource/org/todo"))
;; (setq org-default-notes-file "~/resource/org/todo/main.org")
;; (setq org-agenda-custom-commands
;;     '(
;;         ("c" "Simple agenda view" ((agenda "") (alltodo "")))
;;     )
;; )
;; ; Enter insert mode immediately when capturing with evil turned on
;; (add-hook 'org-capture-mode-hook 'evil-insert-state)

;; (setq org-capture-templates
;;     '(
;;       ("t" "Todo" entry
;;           (file+headline "~/resource/org/todo/main.org" "Tasks")
;;           "* TODO %t %?\n "
;;       )
;;     )
;; )
