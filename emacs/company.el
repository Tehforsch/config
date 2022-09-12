(use-package company)

(global-company-mode 1)

(with-eval-after-load 'company (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
(with-eval-after-load 'company (define-key company-active-map (kbd "C-j") 'company-select-next-or-abort))
(with-eval-after-load 'company (define-key company-active-map (kbd "C-k") 'company-select-previous-or-abort))

(setq company-backends '(company-capf ; Standard code completion, powered by LSP or similar
                        company-dabbrev-code ; Completes with words found in open buffers
                        company-keywords ; Keywords for the language
                        company-files ; Filenames etc.
                        company-elisp))

(setq company-idle-delay 0.1)
(setq company-tooltip-maximum-width 500)
(setq company-tooltip-maximum-height 500)
(setq company-tooltip-limit 30)

(setq company-async-redisplay-delay 0.05)
