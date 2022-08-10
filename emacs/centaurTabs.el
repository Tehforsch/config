(use-package centaur-tabs)

(setq centaur-tabs-style "chamfer"
    centaur-tabs-height 16
    centaur-tabs-set-icons t
    centaur-tabs-left-edge-margin ""
    centaur-tabs-right-edge-margin ""
    centaur-tabs-icon-scale-factor 1.0
    centaur-tabs-set-modified-marker nil
    centaur-tabs-show-navigation-buttons nil
    ; Hide markers
    centaur-tabs-show-new-tab-button nil
    centaur-tabs-set-close-button nil
    ; Show modified files
    centaur-tabs-set-modified-marker t
    ; Periodic boundary conditions within a project
    centaur-tabs-cycle-scope 'tabs
    )

(centaur-tabs-group-by-projectile-project)

(centaur-tabs-change-fonts "Source Code Pro" 128)

(centaur-tabs-headline-match)

(defun centaur-tabs-hide-tab (x)
  "Do no to show buffer X in tabs."
  (let ((name (format "%s" x)))
    (or
     ;; Current window is not dedicated window.
     (window-dedicated-p (selected-window))

     ;; Buffer name not match below blacklist.
     (string-prefix-p "*epc" name)
     (string-prefix-p "*helm" name)
     (string-prefix-p "*Helm" name)
     (string-prefix-p "*Compile-Log*" name)
     (string-prefix-p "*lsp" name)
     (string-prefix-p "*company" name)
     (string-prefix-p "*Flycheck" name)
     (string-prefix-p "*tramp" name)
     (string-prefix-p " *Mini" name)
     (string-prefix-p "*help" name)
     (string-prefix-p "*straight" name)
     (string-prefix-p " *temp" name)
     (string-prefix-p "*Help" name)
     (string-prefix-p "*mybuf" name)
     (string-prefix-p "*Messages*" name)
     (string-prefix-p "*scratch*" name)
     (string-prefix-p "*rust-analyzer*" name)
     (string-prefix-p "*rust-analyzer::stderr*" name)

     ;; Is not magit buffer.
     (and (string-prefix-p "magit" name)
	  (not (file-name-extension name)))
     )))


(centaur-tabs-mode t)
