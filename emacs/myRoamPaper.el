;; Create a paper note directly from a reference
(setq name-of-paper-note "paper")

(defun get-link-text-in-paper-note (cite-key)
  (let ((link-to-paper-note (get-link-to-note (get-note-from-title name-of-paper-note)))
        (link-to-paper (concat "cite:" cite-key)))
    (concat link-to-paper-note "\n" link-to-paper)))

(defun helm-find-note-for-paper ()
  "Create and find file for a paper selected by a helm-bibtex prompt."
  (interactive)
  (let* (
         (cite-key (my-helm-find-bibtex-key))
         (nice-key (my-get-autokey-from-cite-key cite-key))
         (title (s-replace "_" " " nice-key))
         (note (get-note-from-title title)))
    (find-or-create-note note (get-link-text-in-paper-note cite-key))))
                                      
(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "_"
      bibtex-autokey-year-title-separator "_"
      bibtex-autokey-titleword-separator "_"
      bibtex-autokey-name-separator "_"
      bibtex-autokey-titlewords 8
      bibtex-autokey-titlewords-stretch 2
      bibtex-autokey-names 2
      bibtex-autokey-titleword-length nil)

(defun my-get-autokey-from-cite-key (cite-key)
  (with-temp-buffer
    (let* (
      (results (org-ref-get-bibtex-key-and-file cite-key))
      (bibfile (cdr results)))
    (insert-file-contents bibfile)
    (bibtex-set-dialect (parsebib-find-bibtex-dialect) t)
    (bibtex-search-entry cite-key nil 0)
    (prog1 (bibtex-generate-autokey)))))

(defun my-helm-find-bibtex-key (&optional arg local-bib input)
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
