; Needed for evil collection?
(setq evil-want-keybinding nil)
(setq evil-want-integration t)

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

(use-package evil-exchange)
(evil-exchange-install)

(use-package evil-commentary)
(evil-commentary-mode)
; Default comment string in files emacs doesnt recognize (no file ending): #
(setq-default comment-start "#")

(define-key evil-normal-state-map (kbd "C-e") 'evil-commentary-line)

; Make substitution global by default (reverse meaning of appending g at end of substitution)
(setq evil-ex-substitute-global t)

(setq dabbrev-case-fold-search nil)

; Define commands to quickly insert/append before/after the current symbol
(defun append-end-of-symbol (&optional text)
  (interactive)
  (goto-char (nth 1 (evil-inner-symbol)))
  (if (eq text nil)
      (evil-insert nil nil nil)
      (insert text)))

(defun insert-beginning-of-symbol (&optional text)
  (interactive)
  (goto-char (nth 0 (evil-inner-symbol)))
  (if (eq text nil)
      (evil-insert nil nil nil)
      (insert text)))

(define-key evil-normal-state-map "ga" 'append-end-of-symbol)
(define-key evil-normal-state-map "gi" 'insert-beginning-of-symbol)

; Automatically go into insert mode when opening a terminal
(defun enter-evil-insert-mode ()
  (evil-insert nil nil nil))
(add-hook 'term-mode-hook 'enter-evil-insert-mode)

(use-package undo-tree)
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
; The following is there to make sure that undo-tree is still enabled, even though Ctrl+Shift+- (the default undo key) is bound to something else (I bound this to font size decrease in visualSettings.el)
(with-eval-after-load 'undo-tree (defun undo-tree-overridden-undo-bindings-p () nil))

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

; Not really an evil setting but since it works with evil, this file is
; what I most closely associate this setting with - makes w and the word
; text objects work on camel case words
(global-subword-mode +1)

; Required so that I can bind C-k in other places and actually get the behavior I want
(define-key evil-insert-state-map (kbd "C-k") nil)
; Required so that I can bind C-p in other places and actually get the behavior I want
(define-key evil-insert-state-map (kbd "C-p") nil)

; No idea why this was necessary suddenly
(setq evil-shift-width 4)
(add-hook 'rustic-mode-hook 
    (lambda () (setq evil-shift-width 4)))

; An attempt to fix the 'could not assert ownership over selection: CLIPBOARD' error i get sometimes when yanking/deleting
(fset 'evil-visual-update-x-selection 'ignore)

(defun move-down ()
  (interactive)
  (evil-next-line 10))

(defun move-up ()
  (interactive)
  (evil-previous-line 10))
