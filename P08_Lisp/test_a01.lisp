(print (- (* 10 (+ 4 3 3 1)) 20))

(defun faku (n)
  (if (< n 2) 1
    ;; else
    (* n (faku (- n 1)))))

(defun pr (val) (format t "~%--> ~s~%~%" val))
(pr (faku 20))

;; c. get y
(print (car (cdadar '((w (x y))))))

(print (cadr '((w u) y z)))

(print (caddar '((w (x) y) u)))

(print (caaaar '((((y))) w)))


(defun sqr (n)
  (* n n))
  
(prRes (mapcar #'sqr '(81 4 9 1 16)))