;; PSPP P09 schuejen
(format t "P09 - Aufgabe 3 - Factorial~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

;;
;; Factorial with range
;;
(defun range-rek (a b c)
  (cond ((or (= c 0) (or (and (> c 0) (>= a b)) (and (< c 0) (<= a b)))) nil)
    (t (cons a (range-rek (+ a c) b c)))))

(defun range (&rest args)
  (cond ((< (list-length args) 1) nil)
    (t
      (range-rek
        (if (= (list-length args) 1) 0 (car args))
        (or (cadr args) (car args))
        (or (caddr args) 1)))))

(defun factorial (n)
  (if (< n 2) 1
    (apply #'* (range 1 (1+ n)))))

(pr '("factorial 0"))
(prRes (factorial 0))
(pr '("factorial 1"))
(prRes (factorial 1))
(pr '("factorial 2"))
(prRes (factorial 2))
(pr '("factorial 5"))
(prRes (factorial 5))
(pr '("factorial 20"))
(prRes (factorial 20))
