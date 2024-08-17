;; -*- coding: utf-8; lexical-binding: t; -*-
;; POD-mode

(defvar pod-renderer '())
(defvar pod-render-options '())

(setq pod-renderer "pod2html")
(setq pod-render-options "")

;; Renderers read from stdin by default, so we shell out to them
(defun pod-render-buffer ()
  "Render the current POD buffer"
  (interactive)
  (shell-command-on-region 1 (buffer-size) (concat pod-renderer " " pod-render-options) "*pod-render-output*"))

(defun pod-show-html ()
  "Show the rendered POD output"
  (interactive)
  (pod-render-buffer)
  (shr-render-buffer "*pod-render-output*"))
  
(defun pod-insert-boilerplate ()
  "Insert the =pod ... =cut tags to define the POD area"
  (insert "=pod\n\n\n\n=cut\n"))

(defun pod-check-boilerplate ()
  "Check if the buffer requires boilerplate, and, if it does, insert the boilerplate"
  (if (or (= 0 (buffer-size)) (eq '() (string-match "=pod\n\\(.*\n\\)*=cut" (buffer-substring-no-properties 1 (buffer-size))))) ;; The OR short-circuits, so the substring is never called and therefore doesn't choke!
      (pod-insert-boilerplate)
    ()))

(defun pod-insert-heading (n)
  "Insert heading of type n"
  (interactive)
  (insert (concat "\n=head" (int-to-string n)))
  ()) ;; This doesn't need error handling b/c it's only getting called from the keymap

(defun pod-insert-over ()
  "Insert =over ... =back for lists"
  (interactive)
  (insert "\n=over\n\n\n\n=back\n")
  (re-search-backward "=over")
  (next-line))

(defun pod-insert-item ()
  "Insert =item tag within list"
  (interactive)
  (insert "\n=item "))

(defun pod-insert-begin-end ()
  "Insert =begin ... =end block"
  (interactive)
  (insert "\n=begin\n\n\n\n=end\n"))

(defun pod-insert-for ()
  "Insert =for tag"
  (interactive)
  (insert "\n=for "))

(defun pod-insert-markup (b e)
  "Insert markup tag with beginning string b and end string e (e.g., b = 'L<' and e = '>' for a hyperlink)"
  (interactive)
  (let ((rb (region-beginning)) (re (region-end)))
    (goto-char rb)
    (insert b)
    (goto-char (+ (length b) re))
    (insert e)))

(defun pod-insert-italic-region ()
  "Italicize the region"
  (interactive)
  (pod-insert-markup "I<" ">"))

(defun pod-insert-bold-region ()
  "Bold the region"
  (interactive)
  (pod-insert-markup "B<" ">"))

(defun pod-insert-link-region ()
  "Linkify the region (leaving the address empty)"
  (interactive)
  (pod-insert-markup "L<" "|>"))

(defun pod-insert-code-region ()
  "Format the region as code"
  (interactive)
  (pod-insert-markup "C<" ">"))

(defun pod-insert-space-region ()
  "Format the region as non-breaking space text"
  (interactive)
  (pod-insert-markup "S<" ">"))

(defun pod-insert-italic ()
  "Insert italics and position cursor inside"
  (interactive)
  (insert "I<>")
  (backward-char))

(defun pod-insert-bold ()
  "Insert bold tag and position cursor inside"
  (interactive)
  (insert "B<>")
  (backward-char))

(defun pod-insert-link ()
  "Insert hyperlink and position cursor inside"
  (interactive)
  (insert "L<|>")
  (backward-char)
  (backward-char))

(defun pod-insert-code ()
  "Insert codeblock and position cursor inside"
  (interactive)
  (insert "C<>")
  (backward-char))

(defun pod-insert-escape ()
  "Insert escaped character tag and position cursor inside"
  (interactive)
  (insert "E<>")
  (backward-char))

(defun pod-insert-filename ()
  "Insert filename tag and position cursor inside"
  (interactive)
  (insert "F<>")
  (backward-char))

(defun pod-insert-space ()
  "Insert nonbreaking space text and position cursor inside"
  (interactive)
  (insert "S<>")
  (backward-char))

(defun pod-insert-null ()
  "Insert null tag"
  (interactive)
  (insert "Z<>"))

(defvar pod-mode-hook '() "POD mode hook")
(add-hook 'pod-mode-hook 'pod-check-boilerplate)

(defvar pod-mode-map (make-sparse-keymap) "POD mode keymap")
(define-key pod-mode-map (kbd "C-c M-l") 'pod-insert-over)
(define-key pod-mode-map (kbd "C-c M-i") 'pod-insert-item)
(define-key pod-mode-map (kbd "C-c M-b") 'pod-insert-begin-end)
(define-key pod-mode-map (kbd "C-c M-f") 'pod-insert-for)
(define-key pod-mode-map (kbd "C-c C-S-i") 'pod-insert-italic-region)
(define-key pod-mode-map (kbd "C-c C-S-b") 'pod-insert-bold-region)
(define-key pod-mode-map (kbd "C-c C-S-l") 'pod-insert-link-region)
(define-key pod-mode-map (kbd "C-c C-S-c") 'pod-insert-code-region)
(define-key pod-mode-map (kbd "C-c C-S-s") 'pod-insert-space-region)
(define-key pod-mode-map (kbd "C-c C-i") 'pod-insert-italic)
(define-key pod-mode-map (kbd "C-c C-b") 'pod-insert-bold)
(define-key pod-mode-map (kbd "C-c C-l") 'pod-insert-link)
(define-key pod-mode-map (kbd "C-c C-c") 'pod-insert-code)
(define-key pod-mode-map (kbd "C-c C-e") 'pod-insert-escape)
(define-key pod-mode-map (kbd "C-c C-f") 'pod-insert-filename)
(define-key pod-mode-map (kbd "C-c C-s") 'pod-insert-space)
(define-key pod-mode-map (kbd "C-c C-z") 'pod-insert-null)
(define-key pod-mode-map (kbd "C-c C-1") '(lambda () (pod-insert-heading 1)))
(define-key pod-mode-map (kbd "C-c C-2") '(lambda () (pod-insert-heading 2)))
(define-key pod-mode-map (kbd "C-c C-3") '(lambda () (pod-insert-heading 3)))
(define-key pod-mode-map (kbd "C-c C-4") '(lambda () (pod-insert-heading 4)))
(define-key pod-mode-map (kbd "C-c C-5") '(lambda () (pod-insert-heading 5)))
(define-key pod-mode-map (kbd "C-c C-6") '(lambda () (pod-insert-heading 6)))
(define-key pod-mode-map (kbd "C-c C-r") 'pod-render-buffer)
(define-key pod-mode-map (kbd "C-c M-r") 'pod-show-html)

(define-derived-mode pod-mode text-mode "POD"
  "Major mode for editing Plain Old Documentation (POD)"
  (use-local-map pod-mode-map)
  (run-hooks 'pod-mode-hook))

(provide 'pod-mode)
