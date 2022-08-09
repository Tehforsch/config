(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-group-by-projectile-project)
   (setq centaur-tabs-style "alternate"
	  centaur-tabs-height 32
	  centaur-tabs-set-icons t
	  centaur-tabs-set-modified-marker nil
	  centaur-tabs-show-navigation-buttons nil
          ; Hide markers
          centaur-tabs-show-new-tab-button nil
          centaur-tabs-set-close-button nil
          ; Show modified files
          centaur-tabs-set-modified-marker t
          ; Periodic boundary conditions within a project
          centaur-tabs-cycle-scope 'tabs
          )
  )

(setq centaur-tabs-style "alternate")
