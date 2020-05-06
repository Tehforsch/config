(defun pundit--get-link-text-in-paper-note (cite-key)
  (let ((link-to-paper-note (pundit--get-link-to-note (pundit--get-note-from-title pundit-paper-note-name)))
        (link-to-paper (concat "cite:" cite-key)))
    (concat link-to-paper-note "\n" link-to-paper)))

(defun pundit-helm-find-or-create-note-for-paper ()
  "Create and find file for a paper selected by a helm-bibtex prompt."
  (interactive)
  (let* (
         (cite-key (pundit--helm-find-bibtex-key))
         (nice-key (pundit--get-autokey-from-cite-key cite-key))
         (title (s-replace "_" " " nice-key))
         (note (pundit--get-note-from-title title)))
    (pundit--find-or-create-note note (pundit--get-link-text-in-paper-note cite-key))))
                                      
(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "_"
      bibtex-autokey-year-title-separator "_"
      bibtex-autokey-titleword-separator "_"
      bibtex-autokey-name-separator "_"
      bibtex-autokey-titlewords 8
      bibtex-autokey-titlewords-stretch 2
      bibtex-autokey-names 2
      bibtex-autokey-titleword-length nil)

(defun pundit--get-autokey-from-cite-key (cite-key)
  (with-temp-buffer
    (let ((results (org-ref-get-bibtex-key-and-file cite-key)))
      (if (null (cdr results))
          (error "No such citekey in any bib-file %s" cite-key))
      (let ((bibfile (cdr results)))
        (insert-file-contents bibfile)
        (bibtex-set-dialect (parsebib-find-bibtex-dialect) t)
        (bibtex-search-entry cite-key nil 0)
        (prog1 (bibtex-generate-autokey))))))

(defun pundit--helm-find-bibtex-key (&optional arg local-bib input)
  (when arg
    (bibtex-completion-clear-cache))
    (bibtex-completion-init)
    (helm :sources (helm-build-sync-source
                     "My Helm Bibtex"
                     :candidates 'helm-bibtex-candidates
                     :filtered-candidate-transformer 'helm-bibtex-candidates-formatter
                     )
          :bibtex-candidates (bibtex-completion-candidates)
          :bibtex-local-bib local-bib)
)

