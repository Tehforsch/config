(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.pdf\\'" . "zathura \"%s\"")
        ("\\.epub\\'" . "zathura \"%s\"")))
