; Still needed for cape
(use-package company)

(setq company-backends '(company-capf ; Standard code completion, powered by LSP or similar
                        company-dabbrev-code ; Completes with words found in open buffers
                        company-keywords ; Keywords for the language
                        company-files ; Filenames etc.
                        company-elisp))

(setq company-idle-delay nil)
