(require 'subr-x)

; Most of this code is just a translation of fzf.el to pundit.el. Credit goes to
; https://github.com/bling/fzf.el

(defgroup rpundit nil
  "Configuration options for rpundit.el"
  :group 'convenience)

(defcustom rpundit/window-height 15
  "The window height of the rpundit buffer"
  :type 'integer
  :group 'rpundit)

(defcustom rpundit/executable "rpundit"
  "The path to the rpundit executable."
  :type 'string
  :group 'rpundit)

(defcustom rpundit/directory "rpundit"
  "The path to the rpundit folder."
  :type 'string
  :group 'rpundit)

(defcustom rpundit/position-bottom t
  "Set the position of the rpundit window. Set to nil to position on top."
  :type 'bool
  :group 'rpundit)

(defun rpundit/after-term-handle-exit (process-name msg)
  (let* ((text (buffer-substring-no-properties (point-min) (point-max)))
         (lines (split-string text "\n" t "\s*>\s+"))
         (line (car (last (butlast lines 1))))
         (filename (string-trim (substring line (cl-search "/" line))))); Certainly not proud of it but I can't seem to get the typed query to show up in front of the filename in pundit. This WONT work if the query contains a slash.
    (kill-buffer "*rpundit*")
    (when (cl-find "Error" text)
        (message text))
    (jump-to-register :rpundit-windows)
    (when (file-exists-p filename)
      (find-file filename)))
  (advice-remove 'term-handle-exit #'rpundit/after-term-handle-exit))

(defun rpundit/start (directory command)
  (require 'term)
  (window-configuration-to-register :rpundit-windows)
  (advice-add 'term-handle-exit :after #'rpundit/after-term-handle-exit)
  (let* ((buf (get-buffer-create "*rpundit*"))
         (min-height (min rpundit/window-height (/ (window-height) 2)))
         (window-height (if rpundit/position-bottom (- min-height) min-height))
         (window-system-args (when window-system " --margin=1,0"))
         (rpundit-command (s-concat rpundit/executable " " rpundit/directory " " command)))
    (with-current-buffer buf
      (setq default-directory directory))
    (split-window-vertically window-height)
    (when rpundit/position-bottom (other-window 1))
    (message rpundit-command)
    (make-term "rpundit" "sh" nil "-c" rpundit-command)
    (switch-to-buffer buf)
    (linum-mode 0)
    (visual-line-mode 0)
    ;; disable various settings known to cause artifacts, see #1 for more details
    (setq-local scroll-margin 0)
    (setq-local scroll-conservatively 0)
    (setq-local term-suppress-hard-newline t) ;for paths wider than the window
    (setq-local show-trailing-whitespace nil)
    (setq-local display-line-numbers nil)
    (face-remap-add-relative 'mode-line '(:box nil))

    (term-char-mode)
    (setq mode-line-format (format "   RPUNDIT  %s" directory))))

;;;###autoload
(defun rpundit-find ()
  "Starts a rpundit session."
  (interactive)
  (rpundit/start rpundit/directory "find"))

;;;###autoload
(defun rpundit-find-backlinks ()
  "Starts a rpundit session showing the backlinks for the current file."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "backlinks " (buffer-file-name))))
