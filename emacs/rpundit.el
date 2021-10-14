(require 'subr-x)
; Most of this code is just a translation of fzf.el to pundit.el. Credit goes to
; https://github.com/blint/fzf.el

(defgroup rpundit nil
  "Configuration options for rpundit.el"
  :group 'convenience)

(defcustom rpundit/window-height 15
  "The window height of the rpundit buffer"
  :type 'integer
  :group 'rpundit)

(defcustom rpundit/executable "pundit"
  "The path to the rpundit executable."
  :type 'string
  :group 'rpundit)

(defcustom rpundit/directory "~/notes"
  "The path to the rpundit folder."
  :type 'string
  :group 'rpundit)

(defcustom rpundit/position-bottom t
  "Set the position of the rpundit window. Set to nil to position on top."
  :type 'bool
  :group 'rpundit)

(defun rpundit/default-after-term-cleanup ()
  (let ((text (buffer-substring-no-properties (point-min) (point-max))))
    (kill-buffer "*rpundit*")
    (jump-to-register :rpundit-windows)))

(defun rpundit/is-output-line (line)
  (s-starts-with-p "OUTPUT" line))

(defun rpundit/get-pundit-output-from-lines (lines)
  (let ((filtered-lines (cl-remove-if-not #'rpundit/is-output-line lines)))
    (mapcar #'(lambda (line) (string-trim line "OUTPUT")) filtered-lines)))

(defun rpundit/get-pundit-output ()
  (let* ((text (buffer-substring-no-properties (point-min) (point-max)))
         (lines (split-string text "\n" t))
         (relevant-lines (rpundit/get-pundit-output-from-lines lines))
         (num-lines (length relevant-lines)))
    (when (> num-lines 0) (s-join "\n" relevant-lines))))

(defun rpundit/after-term-handle-exit-open-file (process-name msg)
  (let* ((filename (rpundit/get-pundit-output)))
    (rpundit/default-after-term-cleanup)
    (advice-remove 'term-handle-exit #'rpundit/after-term-handle-exit-open-file)
    (if filename 
          (when (file-exists-p filename)
            (find-file filename)))))

(defun rpundit/cleanup-and-insert-link-text (insert-func)
  (let* ((link-text (rpundit/get-pundit-output)))
    (rpundit/default-after-term-cleanup)
    (when link-text
        (funcall insert-func link-text))))
      
(defun rpundit/cleanup-and-insert-anki-note-text ()
  (let* ((anki-note-text (rpundit/get-pundit-output)))
    (rpundit/default-after-term-cleanup)
    (when anki-note-text
        (funcall 'insert anki-note-text))))
      
(defun rpundit/append-text (text)
  (progn (evil-append nil nil nil) (insert text)))

(defun rpundit/after-term-handle-exit-show-link-append (process-name msg)
  (rpundit/cleanup-and-insert-link-text 'rpundit/append-text)
  (advice-remove 'term-handle-exit #'rpundit/after-term-handle-exit-show-link-append))

(defun rpundit/after-term-handle-exit-show-link-insert (process-name msg)
  (rpundit/cleanup-and-insert-link-text 'insert)
  (advice-remove 'term-handle-exit #'rpundit/after-term-handle-exit-show-link-insert))

(defun rpundit/after-term-handle-exit-get-anki-note (process-name msg)
  (rpundit/cleanup-and-insert-anki-note-text)
  (advice-remove 'term-handle-exit #'rpundit/after-term-handle-exit-get-anki-note))

(defun rpundit/start (directory command custom-after-term-handle)
  (require 'term)
  (window-configuration-to-register :rpundit-windows)
  (advice-add 'term-handle-exit :after custom-after-term-handle)
  (let* ((buf (get-buffer-create "*rpundit*"))
         (min-height (min rpundit/window-height (/ (window-height) 2)))
         (window-height (if rpundit/position-bottom (- min-height) min-height))
         (window-system-args (when window-system " --margin=0,0"))
         (rpundit-command (s-concat rpundit/executable " --add-identifier " rpundit/directory " " command)))
    (with-current-buffer buf
      (setq default-directory directory))
    (split-window-vertically window-height)
    (when rpundit/position-bottom (other-window 1))
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
    (setq mode-line-format (format "   pundit %s %s" command directory))))

;;;###autoload
(defun rpundit-find ()
  "Starts a rpundit session."
  (interactive)
  (rpundit/start rpundit/directory "find" 'rpundit/after-term-handle-exit-open-file))

;;;###autoload
(defun rpundit-graph-find ()
  "Starts a rpundit session."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "graph " (buffer-file-name)) 'rpundit/after-term-handle-exit-open-file))

;;;###autoload
(defun rpundit-insert-link ()
  "Get a rpundit link."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "link " (buffer-file-name)) 'rpundit/after-term-handle-exit-show-link-insert))

;;;###autoload
(defun rpundit-append-link ()
  "Get a rpundit link."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "link " (buffer-file-name)) 'rpundit/after-term-handle-exit-show-link-append))

;;;###autoload
(defun rpundit-find-backlinks ()
  "Starts a rpundit session showing the backlinks for the current file."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "backlinks " (buffer-file-name)) 'rpundit/after-term-handle-exit-open-file) )

;;;###autoload
(defun rpundit-find-paper ()
  "Interactively select a paper from a list of papers in the bibtex file and find (or create) the corresponding for the selected paper."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "paper " rpundit/bibtex-file " find") 'rpundit/after-term-handle-exit-open-file))

;;;###autoload
(defun rpundit-journal-yesterday (journal-name)
  "Open a journal for yesterday"
  (rpundit/journal-command "yesterday" journal-name))

;;;###autoload
(defun rpundit-journal-today (journal-name)
  "Open a journal for today"
  (rpundit/journal-command "today" journal-name))

;;;###autoload
(defun rpundit/journal-command (command-name journal-name)
  (rpundit/start rpundit/directory (s-concat "journal " journal-name " " command-name) 'rpundit/after-term-handle-exit-open-file))

;;;###autoload
(defun rpundit-get-new-anki-note ()
  "Add a new anki note entry in the current note"
  (interactive)
  (rpundit/start rpundit/directory (s-concat "pankit-get-note " rpundit/anki-collection) 'rpundit/after-term-handle-exit-get-anki-note))

;;;###autoload
(defun rpundit-get-new-anki-note-check-file-for-model-and-deck ()
  "Add a new anki note entry in the current note. Let pundit figure out the model and deck if there are any already used in the current file."
  (interactive)
  (rpundit/start rpundit/directory (s-concat "pankit-get-note " rpundit/anki-collection " " (buffer-file-name)) 'rpundit/after-term-handle-exit-get-anki-note))

;;;###autoload
(defun rpundit-journal-previous (journal-name)
  "Open the journal entry before the current one"
  (rpundit/journal-command (s-concat "previous " (buffer-file-name)) journal-name))

;;;###autoload
(defun rpundit-journal-next (journal-name)
  "Open the journal entry after the current one"
  (rpundit/journal-command (s-concat "next " (buffer-file-name)) journal-name))

;;;###autoload
(defun rpundit-journal-day-before (journal-name)
  "Open the journal for the day before the current one"
  (rpundit/journal-command (s-concat "day-before " (buffer-file-name)) journal-name))

;;;###autoload
(defun rpundit-journal-day-after (journal-name)
  "Open the journal for the day after the current one"
  (rpundit/journal-command (s-concat "day-after " (buffer-file-name)) journal-name))
