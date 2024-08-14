(use-package tree-sitter)
(use-package tree-sitter-langs)
(add-hook 'rustic-mode-hook 'tree-sitter-mode)
(add-hook 'rustic-mode-hook 'tree-sitter-hl-mode)
(add-to-list
  'tree-sitter-major-mode-language-alist
  '(rustic-mode . rust))
(add-hook 'python-mode-hook 'tree-sitter-mode)
(add-hook 'python-mode-hook 'tree-sitter-hl-mode)
(add-hook 'c-mode-hook 'tree-sitter-mode)
(add-hook 'c-mode-hook 'tree-sitter-hl-mode)

(use-package evil-textobj-tree-sitter :ensure t)

;;;###autoload
; Adapted version of evil-textobj-tree-sitter-get-textobj which only returns a text object if
; Point is contained within the text object region
(defmacro my-evil-textobj-tree-sitter-get-textobj (group &optional query)
  (declare (debug t) (indent defun))
  (let* ((groups (if (eq (type-of group) 'string)
                     (list group)
                   group))
         (funsymbol (intern (concat "evil-textobj-tree-sitter-function--"
                                    (mapconcat 'identity groups "-"))))
         (interned-groups (mapcar #'intern groups)))
    `(evil-define-text-object ,funsymbol
       ;; rest argument is named because of compiler warning `argument _ not left unused`
       (count &rest unused)
       (let ((range (evil-textobj-tree-sitter--range count ',interned-groups ,query)))
         ; Only actually return a range when point is contained within in
         (if (and (and (not (eq range nil)) (>= (point) (car range))) (<= (point) (cdr range)))
             (evil-range (car range)
                         (cdr range))
           (message (concat "No '" ,group "' text object found")))))))



(add-hook 'tree-sitter-mode-hook 'my-setup-evil-tree-sitter-textobjs)

(defun my-setup-evil-tree-sitter-textobjs ()
    (define-key evil-outer-text-objects-map "f" (my-evil-textobj-tree-sitter-get-textobj "function.outer"))
    (define-key evil-inner-text-objects-map "f" (my-evil-textobj-tree-sitter-get-textobj "function.inner"))

    (define-key evil-inner-text-objects-map "c" (my-evil-textobj-tree-sitter-get-textobj "comment.outer"))
    (define-key evil-outer-text-objects-map "c" (my-evil-textobj-tree-sitter-get-textobj "comment.outer"))

    (define-key evil-inner-text-objects-map "o" (my-evil-textobj-tree-sitter-get-textobj "class.outer"))
    (define-key evil-outer-text-objects-map "o" (my-evil-textobj-tree-sitter-get-textobj "class.outer"))

    ; These are very buggy at the moment. Not activating them
    ;; (define-key evil-inner-text-objects-map "a" (my-evil-textobj-tree-sitter-get-textobj "parameter.inner"))
    ;; (define-key evil-outer-text-objects-map "a" (my-evil-textobj-tree-sitter-get-textobj "parameter.outer"))

    ;; (define-key evil-inner-text-objects-map "o" (my-evil-textobj-tree-sitter-get-textobj "call.inner"))
    ;; (define-key evil-outer-text-objects-map "o" (my-evil-textobj-tree-sitter-get-textobj "call.outer"))

    ;; You can also bind multiple items and we will match the first one we can find
    ;; (define-key evil-outer-text-objects-map "a" (my-evil-textobj-tree-sitter-get-textobj ("conditional.outer" "loop.outer")))
)

(defun goto-start-next-function ()
  (interactive)
  (if tree-sitter-mode
    (evil-textobj-tree-sitter-goto-textobj "function.outer")
    (beginning-of-defun)))

(defun goto-start-previous-function ()
  (interactive)
  (if tree-sitter-mode
    (evil-textobj-tree-sitter-goto-textobj "function.outer" t)
    (beginning-of-defun)))

(defun goto-end-next-function ()
  (interactive)
  (if tree-sitter-mode
    (evil-textobj-tree-sitter-goto-textobj "function.outer" nil t)
    (end-of-defun)))

(defun goto-end-previous-function ()
  (interactive)
  (if tree-sitter-mode
    (evil-textobj-tree-sitter-goto-textobj "function.outer" t t)
    (end-of-defun)))
