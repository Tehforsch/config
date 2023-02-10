; Backup folder
(setq
  backup-by-copying t ; don't clobber symlinks
  backup-directory-alist
  '(("." . "~/.local/share/emacsSaves/")) ; don't litter my fs tree
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t) ; use versioned backups
; Autosave folder
(setq auto-save-file-name-transforms `((".*" "~/.local/share/emacsSaves/" t)))

(setq create-lockfiles nil)
