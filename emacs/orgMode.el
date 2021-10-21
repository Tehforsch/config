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

; Location of todolist/agenda
(setq org-agenda-files '("~/notes/20210519153324-todo.org" "~/notes/20210519152011-guitar_practice.org" "~/notes/20210628213812-work_todo.org"))
(setq org-default-notes-file "~/notes/20210519153324-todo.org")

; My default agenda view with just the next items (those that i need to work on soon) and things scheduled for today + upcoming deadlines

(setq org-agenda-custom-commands
      '(("p" "Personal agenda" ((tags-todo "toProcess")
                            (tags-todo "+next-toProcess")
                            (agenda "" ((org-agenda-span 14)
                                        (org-deadline-warning-days 30)))
                            (tags-todo "+spree-next-toProcess")
                            (tags-todo "-waiting" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
         ((org-agenda-tag-filter-preset '("+personal"))))
        ("w" "Work agenda" ((tags-todo "+toProcess")
                            (tags-todo "+next-toProcess")
                            (agenda "" ((org-agenda-span 14)
                                        (org-deadline-warning-days 30)))
                            (tags-todo "+spree-next-toProcess")
                            (tags-todo "-waiting" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
         ((org-agenda-tag-filter-preset '("+work"))))))

; Make agenda view prettier
(setq org-agenda-prefix-format '(
  (agenda  . " %?-12t% s") ;:%l ")
  (timeline  . "• ")
  (todo  . "• ")
  (tags  . "• ")
  (search . "• ")))

; Dont show repeating entries
(setq org-agenda-show-future-repeats nil)

; Start agenda today, not on monday
(setq org-agenda-start-on-weekday nil)

;Enter insert mode immediately when capturing with evil turned on
(add-hook 'org-capture-mode-hook 'evil-insert-state)

(setq org-capture-templates
    '(
      ("i" "Inbox" entry
          (file+headline org-default-notes-file "Inbox")
          "* TODO %?\n "
      )
    )
)

(defun add-task-to-inbox (task)
  (message task)
  (org-capture nil "i")
  (insert task)
  (evil-save-modified-and-close nil)
)

(defun capture-inbox-task ()
  (interactive)
  (org-capture nil "i"))

; Nicer bullet points
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  
(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(insert textobjects additional calendar))
)

(require 'org-agenda)
(setq org-agenda-sticky 1) ; This allows showing the two agendas side by side in different windows.
(add-hook 'org-agenda-mode-hook
          (lambda ()
                  (local-set-key (kbd "C-s") 'org-agenda-todo)))
(setq org-agenda-skip-scheduled-if-done t)

(defun personal-agenda ()
  (interactive)
  (org-agenda nil "p"))

(defun work-agenda ()
  (interactive)
  (org-agenda nil "w"))

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'tree))

(setq org-archive-location (concat "~/resource/org/todo/archive.org::"))

; Insert another heading under this line
(evil-define-key '(normal insert) org-mode-map (kbd "C-a") 'smart-org-insert)
(evil-define-key '(normal insert) org-mode-map (kbd "C-s") 'org-todo)

; Make org tag selection exit after first chosen tag.
(setq org-fast-tag-selection-single-key t)

; Change behavior of org goto / refile to show all subheadings
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets '((("~/notes/20210519153324-todo.org" "~/notes/20210628213812-work_todo.org" "~/notes/20210519152011-guitar_practice.org" "~/projects/tearexCorpTodo/main.org") :maxlevel . 2)))

; Stolen from https://github.com/edwtjo/evil-org-mode/issues/33
(defun smart-org-insert ()
  "Creates a new heading if currently in a heading, creates a new list item 
   if in a list, or creates a newline if neither."
  (interactive)
  (cond
   ((org-at-heading-p) (org-insert-heading-respect-content) (org-todo) (evil-insert nil nil nil))
   ((org-at-item-p)  (org-insert-item))))

(evil-define-key '(normal insert) org-mode-map (kbd "<S-return>") 'org-insert-heading)

; Make org-open-at-point open the link in the same window
(setq org-link-frame-setup (cons (cons 'file 'find-file) org-link-frame-setup))

; Set day start at 5 AM
(setq org-extend-today-until 5)

(setq org-agenda-window-setup 'current-window)
