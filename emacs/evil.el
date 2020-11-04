(setq evil-want-Y-yank-to-eol t)
(use-package evil)
(setq evil-want-C-i-jump nil)
(evil-mode 1)
; Always use evil
(setq evil-emacs-state-odes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)
; Make Y kill to EOL instead of an effective remap of yy; THIS ISNT WORKING RIGHT NOW
; Disable search from wrapping around the buffer (wrapscan=false)
(setq evil-search-wrap nil)
; Make pasting in visual mode not replace the current killring
(setq-default evil-kill-on-visual-paste nil)

(use-package evil-numbers)

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
; Default C-comment: // is (objectively) much more beautiful than /*, especially for single lines 
(defun comment-c-mode-hook ()
  (setq-local comment-start "//")
  (setq-local comment-padding " ")
  (setq-local comment-end "")
  (setq-local comment-style 'indent))
(add-hook 'c-mode-hook 'comment-c-mode-hook)

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

; More things escape properly, stolen from https://github.com/davvil/.emacs.d/blob/master/init.el
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

; C-c + and C-c - to indent / decrease numbers as in vim but with different key bindings
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)

; Make substitution global by default (reverse meaning of appending g at end of substitution)
(setq evil-ex-substitute-global t)

; evil-args: adds text objects for function arguments
(use-package evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)

(setq dabbrev-case-fold-search nil)

(defun end-of-symbol ()
  (interactive)
  (evil-inner-symbol)
  (evil-backward-char)
)
