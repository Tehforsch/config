; The custom-file is where emacs writes its weird package configurations. I dont want this in my own dotfile because its ugly and messes up version control.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq emacs-config-dir "~/projects/config/emacs/")

(defun load-from-config (name)
  (load (concat emacs-config-dir name)))

(load-from-config "packageSetup.el")
; (package-refresh-contents)



; So since evil removed the following function, virtually all of my packages broke
; while I tried to reinstall. I don't understand how emacs package management works,
; but my best guess is that it just doesn't.
; This is my best attempt at a fix because I just want to start emacs and have it working
(defun evil-add-to-alist (list-var key val &rest elements)
    "Add the assocation of KEY and VAL to the value of LIST-VAR.
    If the list already contains an entry for KEY, update that entry;
    otherwise add at the end of the list."
      (let ((tail (symbol-value list-var)))
            (while (and tail (not (equal (car-safe (car-safe tail)) key)))
                         (setq tail (cdr tail)))
                (if tail
                          (setcar tail (cons key val))
                                (set list-var (append (symbol-value list-var)
                                                                                  (list (cons key val)))))
                    (if elements
                              (with-no-warnings
                                          (apply #'evil-add-to-alist list-var elements))
                                    (symbol-value list-var))))

(load-from-config "loadGeneral.el")

; Language support
(load-from-config "flycheck.el")
(load-from-config "lsp.el")

(load-from-config "evil.el")
(load-from-config "evilSurround.el")
(load-from-config "evilTextObjects.el")
(load-from-config "evilCollection.el")
(load-from-config "evilArgs.el")
(load-from-config "evilMatchit.el")
(load-from-config "betterJumper.el")

(load-from-config "vertico.el")
(load-from-config "orderless.el")
(load-from-config "consult.el")
(load-from-config "marginalia.el")
(load-from-config "company.el")
(load-from-config "corfu.el")
(load-from-config "embark.el")

(load-from-config "evilNumbers.el")
(load-from-config "projectile.el")
(load-from-config "fileAssociations.el")
(load-from-config "expandRegion.el")

(load-from-config "direnv.el")

(load-from-config "magit.el")

; Specific languages
(load-from-config "indent.el")
; (load-from-config "elisp-autofmt.el")
(load-from-config "rust.el")
(load-from-config "c.el")
(load-from-config "python.el")
(load-from-config "latex.el")
(load-from-config "haskell.el")
(load-from-config "gnuplot.el")
(load-from-config "yaml.el")
(load-from-config "wgsl-mode.el")
(load-from-config "nix.el")
(load-from-config "lua.el")

(load-from-config "tree-sitter.el")
(load-from-config "folding.el")

(load-from-config "mouse.el")
(load-from-config "miscSettings.el")

(load-from-config "orgMode.el")
(load-from-config "autosaveAndLock.el")
(load-from-config "terminal.el")
(load-from-config "hercules.el")
(load-from-config "symlinks.el")
(load-from-config "whichFunc.el")
(load-from-config "whichKey.el")
(load-from-config "visualSettings.el")
(load-from-config "formatting.el")
(load-from-config "modeLine.el")
(load-from-config "tabbar.el")
(load-from-config "helpful.el")

(load-from-config "temp.el")

(load-from-config "general.el")
