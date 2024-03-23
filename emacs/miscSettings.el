; Don't ask when opening large files
(setq large-file-warning-threshold nil)

; Don't loop over buffers that are not associated with a file
(add-to-list
  'default-frame-alist
  '(buffer-predicate . buffer-file-name))

; Focus help buffer automatically when using help functions and allow escaping them with escape
;; (evil-set-initial-state 'help-mode 'motion)
(setq help-window-select t)
(add-hook
  'help-mode-hook
  (lambda ()
    (evil-define-key
      'normal
      help-mode-map
      [escape]
      'kill-buffer-and-window)))

; Turn on hideshow by default
(add-hook 'c-mode-hook 'hs-minor-mode)

; Immediately debug when any lisp error occurs
(setq debug-on-error nil)
(defun lisp-debug-settings ()
  (interactive)
  (setq debug-on-error t)
  (setq pp-escape-newlines nil)
  (use-package erefactor)
  (erefactor-highlight-mode nil))

(add-hook 'before-save-hook 'check-file-exists-before-saving)
(defun check-file-exists-before-saving ()
  (when
    (and (buffer-file-name) (not (file-exists-p (buffer-file-name))))
    (error "File does not exist. Beware.")))

(defun save-file-and-run-last-command-in-terminal-to-the-right ()
  (interactive)
  (save-buffer)
  (shell-command
    "~/projects/config/scripts/runLastCommandInTerminalToTheRight.sh"))

(defun
  save-file-and-run-last-command-in-terminal-to-the-right-no-switch-back
  ()
  (interactive)
  (save-buffer)
  (shell-command
    "~/projects/config/scripts/runLastCommandInTerminalToTheRight.sh 0"))

(evil-declare-abort-repeat
  'save-file-and-run-last-command-in-terminal-to-the-right)
(evil-declare-abort-repeat
  'save-file-and-run-last-command-in-terminal-to-the-right-no-switch-back)

(setq xref-search-program 'ripgrep)

(use-package glsl-mode)
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))

; always automatically revert buffers
(global-auto-revert-mode 1)

; Do not scroll beyond buffer extents
(setq scroll-conservatively 101)
; Keep a few lines in sight
(setq scroll-margin 10)

; Weird indentation or spaces after the line cause a warning in makefiles
; which I can't be bothered to think about right now
(setq makefile-warn-suspicious-lines nil)
(defun makefile-warn-suspicious-lines () ())

; Make evil searches center the screen on the result
(defadvice evil-search-forward
  (after evil-search-forward-recenter activate)
  (recenter))
(ad-activate 'evil-search-forward)

(defadvice evil-search-next (after evil-search-next-recenter activate)
  (recenter))
(ad-activate 'evil-search-next)

(defadvice evil-search-previous
  (after evil-search-previous-recenter activate)
  (recenter))
(ad-activate 'evil-search-previous)

; Maybe this disables the annoying TAGS file shit which sometimes happens during completion
(setq tags-revert-without-query t)

(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)
; What the fuck is this^
(setq ring-bell-function 'ignore)
