; Use orderless completion style
(use-package
  orderless
  :init
  (setq
    completion-styles '(orderless basic)
    completion-category-defaults nil))
