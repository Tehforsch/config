(defun python-insert-debug-trace ()
  (interactive)
  (evil-open-above nil)
  (insert "import pdb; pdb.set_trace()")
  (evil-normal-state))

(flycheck-define-checker
  python-mypy
  ""
  :command ("mypy" source-original)
  :error-patterns
  (
    (error
      line-start
      (file-name)
      ":"
      line
      ": error:"
      (message)
      line-end))
  :modes python-mode)

(add-to-list 'flycheck-checkers 'python-mypy t)

(setq lsp-pyls-server-command "/home/toni/.local/bin/pylsp")

(use-package python-black)
(setq python-black-extra-args '("-l" "160"))

(setq-default lsp-pyls-configuration-sources ["pycodestyle"])

(setq lsp-pyls-disable-warning t)

(add-hook 'python-mode-hook
    (lambda ()
       (setq indent-tabs-mode nil)
       (setq tab-width 4)))

(setq flycheck-flake8-maximum-line-length 160)
