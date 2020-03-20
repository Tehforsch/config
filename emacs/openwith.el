(use-package openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.epub\\'" "okular" (file)) ("\\.pdf\\'" "okular" (file))))
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
