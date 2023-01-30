(use-package cape)

(defalias 'cape-dabbrev+lsp+file
  (cape-super-capf #'cape-dabbrev #'lsp-completion-at-point #'cape-file))
