(setq mouse-wheel-progressive-speed nil) ; disable acceleration while scrolling
(setq mouse-wheel-scroll-amount '(5 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

;; Wayland-specific scrolling fixes
(when (eq window-system 'pgtk)
  (setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
  (setq mouse-wheel-progressive-speed nil))

(evil-declare-abort-repeat 'evil-mouse-drag-region)
(evil-declare-abort-repeat 'mouse-set-point)
