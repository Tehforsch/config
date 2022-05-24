(use-package git-gutter)
(global-git-gutter-mode +1)
(custom-set-variables
 '(git-gutter:modified-sign " ")
 '(git-gutter:added-sign "+")
 '(git-gutter:deleted-sign "-"))

(custom-set-variables
 '(git-gutter:hide-gutter t))

(custom-set-variables
 '(git-gutter:ask-p nil))
