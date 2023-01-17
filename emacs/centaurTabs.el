(use-package centaur-tabs)

(setq centaur-tabs-style "chamfer"
    centaur-tabs-height 16
    centaur-tabs-bar-height 16
    centaur-tabs-set-icons t
    centaur-tabs-left-edge-margin ""
    centaur-tabs-right-edge-margin ""
    centaur-tabs-icon-scale-factor 1.0
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
     (string-prefix-p "*Warnings*" name)
     (string-prefix-p "*scratch*" name)
     (string-prefix-p "*rust-analyzer*" name)
     (string-prefix-p "*rust-analyzer::stderr*" name)
     (string-prefix-p "*pyls*" name)
     (string-prefix-p "*pyls::stderr*" name)
     (string-prefix-p "*Shell Command Output*" name)

     ;; Is not magit buffer.
     (and (string-prefix-p "magit" name)
	  (not (file-name-extension name)))
     )))


(centaur-tabs-mode t)

(defun reload-centaur-tabs ()
    (interactive)
    (centaur-tabs-mode 0) (centaur-tabs-mode 1))

; I hope that this will prevent centaur tabs sometimes being in a weird state
(add-hook 'find-file-hook 'reload-centaur-tabs)

(defun my-centaur-tabs-forward ()
    (interactive)
    (setq centaur-tabs--buffer-show-groups nil)
    (centaur-tabs-forward))

(defun my-centaur-tabs-backward ()
    (interactive)
    (setq centaur-tabs--buffer-show-groups nil)
    (centaur-tabs-backward))

(defun my-centaur-tabs-forward-group ()
    (interactive)
    (setq centaur-tabs--buffer-show-groups t)
    (centaur-tabs-backward-group))

(defun my-centaur-tabs-backward-group ()
    (interactive)
    (setq centaur-tabs--buffer-show-groups t)
    (centaur-tabs-backward-group))
