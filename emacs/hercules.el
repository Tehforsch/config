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
    "f" 'consult-project-buffer
    "F" 'consult-buffer
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
  )

(hercules-def
 :toggle-funs #'toggle-transient-error
 :hide-funs '(consult-lsp-diagnostics lsp-execute-code-action)
 :keymap 'transient-error-map
 :transient t)


(general-def
    :prefix-map 'transient-journal-map-personal 
    "t" #'((lambda () (interactive) (rpundit-journal-today "journal")) :which-key "Today")
    "y" #'((lambda () (interactive) (rpundit-journal-yesterday "journal")) :which-key "Yesterday")
    "a" #'((lambda () (interactive) (rpundit-journal-day-after "journal")) :which-key "After")
    "b" #'((lambda () (interactive) (rpundit-journal-day-before "journal")) :which-key "Before")
    "n" #'((lambda () (interactive) (rpundit-journal-next "journal")) :which-key "Next")
    "p" #'((lambda () (interactive) (rpundit-journal-previous "journal")) :which-key "Previous")
)

(hercules-def
 :toggle-funs #'toggle-transient-journal-map-personal
 :keymap 'transient-journal-map-personal
 :transient t)

(general-def
    :prefix-map 'transient-journal-map-work 
    "t" #'((lambda () (interactive) (rpundit-journal-today "work")) :which-key "Today")
    "y" #'((lambda () (interactive) (rpundit-journal-yesterday "work")) :which-key "Yesterday")
    "a" #'((lambda () (interactive) (rpundit-journal-day-after "work")) :which-key "After")
    "b" #'((lambda () (interactive) (rpundit-journal-day-before "work")) :which-key "Before")
    "n" #'((lambda () (interactive) (rpundit-journal-next "work")) :which-key "Next")
    "p" #'((lambda () (interactive) (rpundit-journal-previous "work")) :which-key "Previous")
)

(hercules-def
 :toggle-funs #'toggle-transient-journal-map-work
 :keymap 'transient-journal-map-work
 :transient t)
