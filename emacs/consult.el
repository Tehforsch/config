(use-package consult)
(use-package consult-lsp)

(setq consult-project-root-function
    (lambda ()
        (when-let (project (project-current))
        (car (project-roots project)))))

(setq consult-project-root-function #'projectile-project-root)

(setq consult-ripgrep-args "rg --color=never --path-separator / --smart-case --no-heading --line-number --line-buffered --null")

; Make xref show xrefs and xref show definitions use completion-at-point / consult
(setq xref-show-xrefs-function 'consult-xref)
(setq xref-show-definitions-function 'consult-xref)

(setq consult-async-min-input 0)
(setq consult-async-input-debounce 0.01)
(setq consult-async-input-throttle 0.10)


(setq consult-buffer-filter
  '("\\` "
    "\\`\\*.*\\*\\'"))
