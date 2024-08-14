(use-package ts-fold
  :straight (ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold"))

(global-ts-fold-mode)

(defun toggle-fold-eol ()
  (interactive)
  (save-excursion
    (end-of-line)
    (ts-fold-toggle)))



; I took the original definitions from ts-fold and commented out
; the declaration list. This makes `mod { ... }` blocks not fold
; which I prefer (since otherwise pressing fold in a mod tests { ... }
; can easily fold everything)
(defun ts-fold-parsers-rust ()
  "Rule set for Rust."
  '(
    ;; (declaration_list       . ts-fold-range-seq)
    (enum_variant_list      . ts-fold-range-seq)
    (field_declaration_list . ts-fold-range-seq)
    (use_list               . ts-fold-range-seq)
    (field_initializer_list . ts-fold-range-seq)
    (match_block            . ts-fold-range-seq)
    (macro_definition       . (ts-fold-range-rust-macro 1 -1))
    (block                  . ts-fold-range-seq)
    (token_tree             . ts-fold-range-seq)
    (line_comment
     . (lambda (node offset)
         (ts-fold-range-line-comment node
                                     (ts-fold--cons-add offset '(0 . -1))
                                     "///")))
    (block_comment          . ts-fold-range-block-comment)
    ))

(setf (alist-get 'rustic-mode ts-fold-range-alist) (ts-fold-parsers-rust))
