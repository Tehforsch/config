(setq mouse-wheel-progressive-speed nil) ; disable acceleration while scrolling
(setq mouse-wheel-scroll-amount '(5 ((shift) . 5) ((control) . nil)))

(evil-declare-abort-repeat 'evil-mouse-drag-region)
(evil-declare-abort-repeat 'mouse-set-point)
