(print (- (* 10 (+ 4 3 3 1)) 20))

(defun faku (n)
  (if (< n 2) 1
    ;; else
    (* n (faku (- n 1)))))

(defun pr (val) (format t "~%--> ~s~%~%" val))
(pr (faku 20))

;; c. get y
(cdadar '((w (x y))))

(cadr '((w u) y z))

(caddar '((w (x) y) u))

(caaaar '((((y))) w))
