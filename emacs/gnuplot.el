(use-package gnuplot)
(add-to-list 'auto-mode-alist '("\\.gp\\'" . gnuplot-mode))

(add-hook 'gnuplot-mode-hook 'display-line-numbers-mode)
