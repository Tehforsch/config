(use-package flycheck)
(setq flycheck-check-syntax-automatically '(mode-enabled save))
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))

(use-package helm-flycheck) 

; (use-package flycheck-projectile)

; (defun helm-flycheck-projectile-errors ()
;   (let* ((project (projectile-acquire-root nil))
;                  (list (flycheck-projectile--make-error-list project)))
;     (message list)))

; (helm-flycheck-projectile-errors)
