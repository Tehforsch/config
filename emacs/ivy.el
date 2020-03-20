(use-package ivy
    :config
    (ivy-mode 1)
    (define-key ivy-minibuffer-map (kbd "<C-return>") 'ivy-immediate-done)
)
; Make C-w, C-j, C-k and escape behave properly
(define-key ivy-minibuffer-map (kbd "C-w") 'evil-delete-backward-word)
(define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
(define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
(define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
