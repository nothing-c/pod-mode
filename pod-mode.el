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
  (insert "=over\n\n\n\n=back\n")
  (re-search-backward "=over")
  (next-line))

(provide 'pod-mode)

