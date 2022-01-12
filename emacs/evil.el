; Needed for evil collection?
(setq evil-want-keybinding nil)
(setq evil-want-integration nil)

(setq evil-want-C-u-delete t)
(setq evil-want-C-u-scroll t)

(setq evil-want-Y-yank-to-eol t)
(setq evil-want-C-i-jump t)
(setq evil-emacs-state-odes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)

(use-package evil)
(evil-mode 1)
; Disable search from wrapping around the buffer (wrapscan=false)
(setq evil-search-wrap nil)
; Make pasting in visual mode not replace the current killring
(setq-default evil-kill-on-visual-paste nil)

(use-package evil-surround
    :config
; Remap S to surround instead of ys, S is usually replace entire line which i never use (theres cc for that)
    (evil-define-key 'normal evil-surround-mode-map "S" 'evil-surround-region)
)
(global-evil-surround-mode 1)

(use-package evil-exchange)
(evil-exchange-install)

(use-package evil-commentary)
(evil-commentary-mode)
; Default comment string in files emacs doesnt recognize (no file ending): #
(setq-default comment-start "#")

(define-key evil-normal-state-map (kbd "C-e") 'evil-commentary-line)

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
; Bind it to both possible keys
(define-key evil-inner-text-objects-map "f" 'evil-inner-function)
(define-key evil-outer-text-objects-map "f" 'evil-inner-function)

; Bind text objects for symbols to "s" which is much nicer to reach than o, especially when pressing cis (instead of cio)
(define-key evil-inner-text-objects-map "s" 'evil-inner-symbol)
(define-key evil-outer-text-objects-map "s" 'evil-inner-symbol)
; Bind the sentence thing to "S" instead, in case I might need it
(define-key evil-inner-text-objects-map "S" 'evil-inner-sentence)
(define-key evil-outer-text-objects-map "S" 'evil-inner-sentence)

; Make substitution global by default (reverse meaning of appending g at end of substitution)
(setq evil-ex-substitute-global t)

(setq dabbrev-case-fold-search nil)

; Define commands to quickly insert/append before/after the current symbol
(defun append-end-of-symbol ()
  (interactive)
  (apply #'evil-visual-char (evil-inner-symbol))
  (evil-backward-char)
  (evil-append nil nil nil))

(defun insert-beginning-of-symbol ()
  (interactive)
  (apply #'evil-visual-char (evil-inner-symbol))
  (exchange-point-and-mark)
  (evil-insert nil nil nil))

(define-key evil-normal-state-map "ga" 'append-end-of-symbol)
(define-key evil-normal-state-map "gi" 'insert-beginning-of-symbol)

(defun goto-end-of-symbol ()
  (interactive)
  (apply #'evil-visual-char (evil-inner-symbol))
  (evil-exit-visual-state)
  (evil-backward-char))

(define-key evil-normal-state-map "E" 'goto-end-of-symbol)

; Automatically go into insert mode when opening a terminal
(defun enter-evil-insert-mode ()
  (evil-insert nil nil nil))
(add-hook 'term-mode-hook 'enter-evil-insert-mode)

(use-package undo-tree)
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

; Make sure we cant repeat undo / repeat with .
(evil-declare-abort-repeat 'evil-undo)
(evil-declare-abort-repeat 'evil-redo)

; Make sure pressing escape does not cancel macro recording
(defun keyboard-quit-when-not-recording-macro ()
  (interactive)
  (when (not defining-kbd-macro)
      (keyboard-quit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit-when-not-recording-macro)
(define-key evil-visual-state-map [escape] 'keyboard-quit-when-not-recording-macro)

; I never write html so this is a saner default for me instead of adding tags
(setq-default evil-surround-pairs-alist (push '(?< . ("<" . ">")) evil-surround-pairs-alist))

; Not really an evil setting but since it works with evil, this file is
; what I most closely associate this setting with - makes w and the word
; text objects work on camel case words
(global-subword-mode +1)
