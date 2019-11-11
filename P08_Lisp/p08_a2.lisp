;; PSPP P08 schuejen
;; Aufgabe 2
(format t "Aufgabe 2 - Funktionen ohne map-list~%")
; Formatted print
(defun pr (val) (format t "~%--> ~s~%" val))

; square every item in list
(defun list-sqr (lst)
  (if (null lst) nil
    (cons (* (car lst) (car lst))
      (list-sqr (cdr lst)))))


; double every item in list
(defun list-double (lst)
  (if (null lst)
    nil
    (cons (* 2 (car lst)) (list-double (cdr lst)))))

(format t "~%list-double '(1 2 3 4)")
(pr (list-double '(1 2 3 4)))


; return sign of number
(defun sign (n)
  (if (> n 0)
    1
    (if (= n 0)
      0
      -1)))

(format t "~%sign '-62")
(pr (sign '-62))
(format t "~%sign '0")
(pr (sign '0))
(format t "~%sign '2")
(pr (sign '2))


; return sign of every item in list
(defun list-sign (lst)
  (if (null lst)
    nil
    (cons (sign (car lst)) (list-sign (cdr lst)))))

(format t "~%list-sign '(5 2 -3 -1 0 3 -2)")
(pr (list-sign '(5 2 -3 -1 0 3 -2)))
