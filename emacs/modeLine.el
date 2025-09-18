(use-package doom-modeline
  :ensure t
  :init 
  (doom-modeline-mode 1)
  ;; Move modeline to header
  (setq-default mode-line-format nil)
  (setq-default header-line-format '(:eval (doom-modeline-format--main)))
  :config
  (setq doom-modeline-icon t
        doom-modeline-height 25
        doom-modeline-bar-width 10
        doom-modeline-project-detection 'projectile
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-buffer-state-icon nil
        doom-modeline-buffer-modification-icon nil
        doom-modeline-major-mode-icon nil
        doom-modeline-major-mode-name nil
        doom-modeline-major-mode-color-icon nil
        doom-modeline-enable-word-count nil
        doom-modeline-continuous-word-count-modes nil
        doom-modeline-percent-position nil
        doom-modeline-position-line-format nil
        doom-modeline-position-column-format nil
        doom-modeline-column-zero-based nil
        doom-modeline-buffer-encoding nil
        doom-modeline-env-version nil
        doom-modeline-process nil
        doom-modeline-modal nil
        doom-modeline-checker-simple-format t
        doom-modeline-vcs-max-length 35)
  ;; Customize modeline segments to remove extra spacing
  (doom-modeline-def-modeline 'main
    '(buffer-info buffer-position)
    '(process vcs)))

;; Make header line face match modeline and force active appearance
(set-face-attribute 'header-line nil 
                    :background "#665c54"
                    :foreground "#d5c4a1"
                    :box nil
                    :inherit 'mode-line)

;; ;; Force mode-line-inactive to look like active mode-line
;; (set-face-attribute 'mode-line-inactive nil
;;                     :background "#665c54"
;;                     :foreground "#d5c4a1"
;;                     :box (face-attribute 'mode-line :box)
;;                     :inherit 'mode-line)
