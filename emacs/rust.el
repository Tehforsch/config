(use-package rust-mode)
(add-hook 'rust-mode-hook 'rust-enable-format-on-save)
(setq rust-format-show-buffer nil)
