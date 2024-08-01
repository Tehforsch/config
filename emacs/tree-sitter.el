(require 'treesit)

; Shoutout to https://github.com/bitspook/spookmax.d for this. Don't know why I couldn't
; find any other solution for emacs to actually find the installed grammars despite
; adding it with (emacsWithPackages ...) in the nixos config
(let ((nix-treesit-lib-path
       (expand-file-name
        "lib"
        (string-replace
         "\"" ""
         (string-trim
          (shell-command-to-string
           "nix eval nixpkgs#emacsPackages.treesit-grammars.with-all-grammars.outPath")))))) 
  (setf treesit-extra-load-path (list nix-treesit-lib-path)))

(use-package treesit-auto)
(global-treesit-auto-mode)
(delete 'rust treesit-auto-langs)

(setq treesit-font-lock-level 4)

; Everytime I check this again virtually none of the textobjects work for me :|
(use-package evil-textobj-tree-sitter :ensure t)

(define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
(define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))

(define-key evil-outer-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.outer"))
(define-key evil-inner-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.inner"))

; Overwrite this to make sure even rustic mode gets the message that
;we are using builtin treesitter
(defun  evil-textobj-tree-sitter--use-builtin-treesitter () t)

;; Goto start of next function
(define-key evil-normal-state-map
            (kbd "]f")
            (lambda ()
              (interactive)
              (evil-textobj-tree-sitter-goto-textobj "parameters.outer")))
