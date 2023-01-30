(use-package
  tabbar
  :ensure t


  :init
  (progn
    (tabbar-mode t)
    (setq tabbar-use-images nil)
    (set-face-attribute 'tabbar-default nil
      :background "#3c3836"
      :foreground "#ebdbb2"
      :box '(:line-width 1 :color "#3c3836" :style nil))
    (set-face-attribute 'tabbar-unselected nil
      :background "#3c3836"
      :foreground "#ebdbb2"
      :box '(:line-width 5 :color "#3c3836" :style nil))
    (set-face-attribute 'tabbar-modified nil
      :background "#3c3836"
      :foreground "#ebdbb2"
      :box '(:line-width 5 :color "#3c3836" :style nil))
    (set-face-attribute 'tabbar-selected nil
      :background "#3c3836"
      :foreground "#fabd2f"
      :box '(:line-width 5 :color "#3c3836" :style nil))
    (set-face-attribute 'tabbar-highlight nil
      :background "white"
      :foreground "black"
      :underline nil
      :box '(:line-width 5 :color "white" :style nil))
    (set-face-attribute 'tabbar-button nil
      :box '(:line-width 1 :color "gray20" :style nil))
    (set-face-attribute 'tabbar-separator nil
      :background "gray20"
      :height 0.6)))

; Hide the buttons
(defsubst tabbar-line-buttons (tabset)
  "Return a list of propertized strings for tab bar buttons.
TABSET is the tab set used to choose the appropriate buttons."
  (list (propertize "")))

; Modified from https://www.emacswiki.org/emacs/TabBarMode:
; Combines all *blabla* buffers into the emacs group and groups all others by
; the a shared git dir
(defun git-tabbar-buffer-groups ()
  "Groups tabs in tabbar-mode by the git repository they are in."
  (list
    (cond
      ((string-equal "*" (substring (buffer-name) 0 1))
        "emacs")
      ((eq major-mode 'dired-mode)
        "emacs")
      (t
        (find-git-dir (buffer-file-name (current-buffer)))))))

(setq tabbar-buffer-groups-function 'git-tabbar-buffer-groups)

(defun find-git-dir (dir)
  "Search up the directory tree looking for a .git folder."
  (cond
    ((eq major-mode 'dired-mode)
      "Dired")
    ((not dir)
      "process")
    ((string= dir "/")
      "no-git")
    ((file-exists-p (concat dir "/.git"))
      dir)
    (t
      (find-git-dir
        (directory-file-name (file-name-directory dir))))))
