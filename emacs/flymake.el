(use-package popup)

(use-package flymake-diagnostic-at-point
  :after flymake
  :config
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))

(setq flymake-diagnostic-at-point-timer-delay 0.0)
(setq flymake-diagnostic-at-point-display-diagnostic-function 'flymake-diagnostic-at-point-display-minibuffer)

(defun flymake-diagnostic-at-point-display-popup-now ()
  (interactive)
  (flymake-diagnostic-at-point-maybe-display))
