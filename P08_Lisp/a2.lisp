
(defun list-double (lst)
  (if (null lst)
    nil
    (cons (* 2 (car lst)) (list-double (cdr list)))))

(defun pr (val) (format t "~%--> ~s~%~%" val))

(pr (list-double '(1 2 3 4)))

(defun list-double (lst)
  (if (null lst)
    nil
    (cons (* 2 (car lst))
      (list-double (cdr lst)))))
