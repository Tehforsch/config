;; Create a paper note directly from a reference
(defun org-roam-find-file-for-paper ()
  "Create and find file for a paper selected by a helm-bibtex prompt."
  (interactive)
  (let* (
         (cite-key (my-helm-find-bibtex-key))
         (nice-key (my-get-autokey-from-cite-key cite-key))
         (title (s-replace "_" " " nice-key))
         (filename (concat nice-key))
         (file-path (org-roam--file-path-from-id filename)))
    (if (file-exists-p file-path)
        (find-file file-path)
      (let ((org-roam-capture-templates (list (list "d" "daily" 'plain (list 'function #'org-roam--capture-get-point)
                                                    ""
                                                    :immediate-finish t
                                                    :file-name "%<%Y%m%d%H%M%S>-${filename}"
                                                    :head "#+TITLE: ${title}\ncite:${cite-key}\n[[file:20200228104457-paper.org][paper]]")))
            (org-roam--capture-context 'title)
            (org-roam--capture-info (list (cons 'title title) (cons 'filename filename) (cons 'cite-key cite-key))))
        (add-hook 'org-capture-after-finalize-hook 'org-capture-goto-last-stored)
        (org-roam-capture)))))
                                      
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