(use-package openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.epub\\'" "zathura" (file)) ("\\.pdf\\'" "zathura" (file))))
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
