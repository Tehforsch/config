(use-package hercules)

(general-def
  :prefix-map 'transient-buffer-map
    "n" #'next-buffer
    "p" #'previous-buffer
    "k" #'tabbar-backward-tab
    "j" #'tabbar-forward-tab
    "K" #'tabbar-backward-group
    "J" #'tabbar-forward-group
    "d" #'kill-this-buffer
    "m" #'((lambda () (interactive) (switch-to-buffer "*Messages*")) :which-key "go to *Messages* buffer")
    "f" 'consult-buffer
    "F" 'consult-project-buffer
    "s" 'evil-save-modified-and-close
)

(hercules-def
 :toggle-funs #'toggle-transient-buffer
 ; Make sure we dont stay in transient mode with these minibuffer popups
 :hide-funs '(consult-buffer consult-project-buffer)
 :keymap 'transient-buffer-map
 :transient t)

(general-def 
  :prefix-map 'transient-window-map
  "h" #'evil-window-left
  "j" #'evil-window-down
  "k" #'evil-window-up
  "l" #'evil-window-right
  "H" #'evil-window-move-far-left
  "J" #'evil-window-move-very-bottom
  "K" #'evil-window-move-very-top
  "L" #'evil-window-move-far-right
  "s" #'evil-window-split
  "S" #'evil-window-vsplit
  "o" #'delete-other-windows
  "f" #'make-frame-delete-window
  "d" #'delete-window
  "+" #'((lambda () (interactive) (enlarge-window 5)) :which-key "Enlarge window")
  "-" #'((lambda () (interactive) (shrink-window 5)) :which-key "Shrink window")
  )

(hercules-def
 :toggle-funs #'toggle-transient-window
 :keymap 'transient-window-map
 :transient t)

(general-def 
  :prefix-map 'transient-error-map
  "n" 'next-error
  "p" 'previous-error
  "l" 'consult-lsp-diagnostics
  "x" 'lsp-execute-code-action
  "s" 'toggle-lsp-ui-sideline-show-diagnostics
  )

(hercules-def
 :toggle-funs #'toggle-transient-error
 :hide-funs '(consult-lsp-diagnostics lsp-execute-code-action toggle-lsp-ui-sideline-show-diagnostics)
 :keymap 'transient-error-map
 :transient t)
