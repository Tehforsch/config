(use-package tree-sitter)
(use-package tree-sitter-langs)
(add-hook 'rustic-mode-hook 'tree-sitter-mode)
(add-hook 'rustic-mode-hook 'tree-sitter-hl-mode)
(add-to-list
  'tree-sitter-major-mode-language-alist
  '(rustic-mode . rust))

; I tried evil-textobj-tree-sitter but a lot of them didn't work properly or behaved in erratic ways, so i'll try this again some time in the future
; (use-package evil-textobj-tree-sitter :ensure t)
