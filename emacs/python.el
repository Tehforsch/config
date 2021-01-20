(defun python-insert-debug-trace ()
  (interactive)
  (evil-open-above nil)
  (insert "import pdb; pdb.set_trace()")
  (evil-normal-state)
)
(flycheck-define-checker
    python-mypy ""
    :command ("mypy"
              "--ignore-missing-imports" "--fast-parser"
              "--python-version" "3.6"
              source-original)
    :error-patterns
    ((error line-start (file-name) ":" line ": error:" (message) line-end))
    :modes python-mode)

(add-to-list 'flycheck-checkers 'python-mypy t)
(flycheck-add-next-checker 'python-pylint 'python-mypy t)

(use-package python-black)
(add-hook 'python-mode-hook 'python-black-on-save-mode)
(setq python-black-extra-args '("-l" "160"))
