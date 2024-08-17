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

(provide 'pod-mode)

