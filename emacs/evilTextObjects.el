; From https://stackoverflow.com/questions/18102004/emacs-evil-mode-how-to-create-a-new-text-object-to-select-words-with-any-non-sp/18688066#18688066, akdom
(defmacro define-and-bind-text-object (key start-regex end-regex inner-name outer-name)
  (let ((inner-name (make-symbol inner-name))
        (outer-name (make-symbol outer-name)))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
       (define-key evil-outer-text-objects-map ,key (quote ,outer-name))))); between dollar signs:
(define-and-bind-text-object "$" "\\$" "\\$" "evil-inner-dollar" "evil-outer-dollar")
; between pipe characters:
(define-and-bind-text-object "|" "|" "|" "evil-inner-pipe" "evil-outer-pipe")

; Define a "defun" Emacs Evil text object (https://github.com/emacs-evil/evil/issues/874) and bind it to f
(evil-define-text-object evil-inner-function (count &optional beg end type)
    "Select inner function."
    (evil-select-inner-object 'evil-defun beg end type count)
)
; Bind it to both possible keys. Note that this will possibly be overwritten by tree-sitter-text-objects
(define-key evil-inner-text-objects-map "f" 'evil-inner-function)
(define-key evil-outer-text-objects-map "f" 'evil-inner-function)

; Bind text objects for symbols to "s" which is much nicer to reach than o, especially when pressing cis (instead of cio)
(define-key evil-inner-text-objects-map "s" 'evil-inner-symbol)
(define-key evil-outer-text-objects-map "s" 'evil-inner-symbol)
; Bind the sentence thing to "S" instead, in case I might need it
(define-key evil-inner-text-objects-map "S" 'evil-inner-sentence)
(define-key evil-outer-text-objects-map "S" 'evil-inner-sentence)
