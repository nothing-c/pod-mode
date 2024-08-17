;; -*- coding: utf-8; lexical-binding: t; -*-
;; POD-mode

(defun pod-insert-boilerplate ()
  "Insert the =pod ... =cut tags to define the POD area"
  (insert "=pod\n\n\n\n=cut\n"))

(defun pod-check-boilerplate ()
  "Check if the buffer requires boilerplate, and, if it does, insert the boilerplate"
  (if (eq '() (string-match "=pod\n\\(.*\n\\)*=cut" (buffer-substring-no-properties 1 (buffer-size))))
      (pod-insert-boilerplate)
    ()))

(defun pod-insert-heading (n)
  "Insert heading of type n"
  (insert (concat "\n=head" (int-to-string n)))
  ()) ;; This doesn't need error handling b/c it's only getting called from the keymap

(defun pod-insert-over ()
  "Insert =over ... =back for lists"
  (insert "\n=over\n\n\n\n=back\n")
  (re-search-backward "=over")
  (next-line))

(defun pod-insert-item ()
  "Insert =item tag within list"
  (insert "\n=item "))

(defun pod-insert-begin-end ()
  "Insert =begin ... =end block"
  (insert "\n=begin\n\n\n\n=end\n"))

(defun pod-insert-for ()
  "Insert =for tag"
  (insert "\n=for "))

(defun pod-insert-markup (b e)
  "Insert markup tag with beginning string b and end string e (e.g., b = 'L<' and e = '>' for a hyperlink)"
  (let ((rb (region-beginning)) (re (region-end)))
    (goto-char rb)
    (insert b)
    (goto-char (+ (length b) re))
    (insert e)))

(defun pod-insert-italic-region ()
  (pod-insert-markup "I<" ">"))

(defun pod-insert-bold-region ()
  (pod-insert-markup "B<" ">"))

(defun pod-insert-link-region ()
  (pod-insert-markup "L<" "|>"))

(defun pod-insert-code-region ()
  (pod-insert-markup "C<" ">"))

(defun pod-insert-space-region ()
  (pod-insert-markup "S<" ">"))

(provide 'pod-mode)

