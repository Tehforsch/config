(use-package popup)

(use-package flymake-diagnostic-at-point
  :after flymake
  :config
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))

(setq flymake-diagnostic-at-point-timer-delay nil)

(defun flymake-diagnostic-at-point-display-popup-now ()
  (interactive)
  (flymake-diagnostic-at-point-maybe-display))
