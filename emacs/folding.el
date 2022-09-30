(defun activate-hs-minor-mode ()
  (hs-minor-mode 1))

(add-hook 'c-mode-hook 'activate-hs-minor-mode)
(add-hook 'rustic-mode-hook 'activate-hs-minor-mode)
