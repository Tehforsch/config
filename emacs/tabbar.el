(use-package tabbar
  :ensure t

  :init
  (progn (tabbar-mode t)
         (setq tabbar-use-images nil)
         (set-face-attribute
          'tabbar-default nil
          :background "#3c3836"
          :foreground "#ebdbb2"
          :box '(:line-width 1 :color "#3c3836" :style nil) )
         (set-face-attribute
          'tabbar-unselected nil
          :background "#3c3836"
          :foreground "#ebdbb2"
          :box '(:line-width 5 :color "#3c3836" :style nil))
         (set-face-attribute
          'tabbar-modified nil
          :background "#3c3836"
          :foreground "#ebdbb2"
          :box '(:line-width 5 :color "#3c3836" :style nil))
         (set-face-attribute
          'tabbar-selected nil
          :background "#3c3836"
          :foreground "#fe8019"
          :box '(:line-width 5 :color "#3c3836" :style nil)) 
         (set-face-attribute
          'tabbar-highlight nil
          :background "white"
          :foreground "black"
          :underline nil
          :box '(:line-width 5 :color "white" :style nil))
         (set-face-attribute
          'tabbar-button nil
          :box '(:line-width 1 :color "gray20" :style nil)
          )
         (set-face-attribute
          'tabbar-separator nil
          :background "gray20"
          :height 0.6)
         ))

; Hide the buttons
(defsubst tabbar-line-buttons (tabset)
  "Return a list of propertized strings for tab bar buttons.
TABSET is the tab set used to choose the appropriate buttons."
  (list (propertize "")))
