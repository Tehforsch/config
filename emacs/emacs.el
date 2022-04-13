; The custom-file is where emacs writes its weird package configurations. I dont want this in my own dotfile because its ugly and messes up version control.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq emacs-config-dir "~/projects/config/emacs/")

(defun load-from-config (name)
  (load (concat emacs-config-dir name)))

(load-from-config "packageSetup.el")
; (package-refresh-contents)

(load-from-config "loadGeneral.el")

; Language support
(load-from-config "flycheck.el")
(load-from-config "lsp.el")

(load-from-config "evil.el")
(load-from-config "evilCollection.el")
(load-from-config "evilArgs.el")
(load-from-config "betterJumper.el")
(load-from-config "selectrum.el")
(load-from-config "consult.el")
(load-from-config "marginalia.el")
(load-from-config "evilNumbers.el")
(load-from-config "projectile.el")
(load-from-config "magit.el")
(load-from-config "fileAssociations.el")
(load-from-config "helm.el")

(load-from-config "treemacs.el")

; Specific languages
(load-from-config "rust.el")
(load-from-config "c.el")
(load-from-config "python.el")
(load-from-config "latex.el")
(load-from-config "gnuplot.el")
(load-from-config "yaml.el")

; Completion
(load-from-config "company.el")

(load-from-config "miscSettings.el")

(load-from-config "orgMode.el")
(load-from-config "autosaveAndLock.el")
(load-from-config "terminal.el")
(load-from-config "hydra.el")
(load-from-config "symlinks.el")
(load-from-config "whichFunc.el")
(load-from-config "whichKey.el")
(load-from-config "visualSettings.el")
(load-from-config "formatting.el")
(load-from-config "modeLine.el")

(load-from-config "punditSettings.el")
(load-from-config "rpundit.el")

(load-from-config "screenshot.el")

(load-from-config "general.el")
