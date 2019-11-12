;; alternative implementation in case the Common Lisp used does not
;; support the read-sequence function
;;
(defun file-to-string (path)
  (with-open-file (stream path)
    (apply #'concatenate 
           (cons 'string 
                 (loop
                   for line = (read-line stream nil 'eof)
                   until (eq line 'eof)
                   collect (format nil "~A~%" line))))))
