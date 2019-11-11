;; PSPP P08 schuejen
;; Aufgabe 3
(format t "Aufgabe 3 - Funktionen mit map-list~%")
; Formatted print
(defun pr (val) (format t "~%--> ~s~%" val))


; map function for calculating
(defun map-calc (f lst neutral)
  (if (null lst)
    neutral
    (funcall f (car lst) (map-calc f (cdr lst) neutral))))

;; list-sum und list-mult unterscheidet sich nur im Operator und am neutralen element (für das Abbruchkriterium)

; sum up list
(defun list-sum (lst)
  (if (null lst)
    0
    (+ (car lst) (list-sum (cdr lst)))))

(format t "~%list-sum '(10 20 7)")
(pr (list-sum '(10 20 7)))

(defun map-list-sum (lst)
  (map-calc #'+ lst 0))

(format t "~%map-list-sum '(10 20 7)")
(pr (map-list-sum '(10 20 7)))


; multiply every item in list
(defun list-mult (lst)
  (if (null lst)
    1
    (* (car lst) (list-mult (cdr lst)))))

(format t "~%list-mult '(10 20 7)")
(pr (list-mult '(10 20 7)))

(defun map-list-mult (lst)
  (map-calc #'* lst 1))

(format t "~%map-list-mult '(10 20 7)")
(pr (map-list-mult '(10 20 7)))


; true if all elements in list are true
(defun all-true (lst)
  (if (null lst)
    T
    (and (car lst) (all-true (cdr lst)))))
; das obere geht, da das letzte element T ist. Alternative:
;    (and (not (eql nil (car lst))) (not (eql nil (all-true (cdr lst)))))))


(format t "~%all-true '(10 20 7)")
(pr (all-true '(10 20 7)))

(format t "~%all-true '()")
(pr (all-true '()))

(format t "~%all-true '(34 hallo 7)")
(pr (all-true '(34 hallo 7)))

(format t "~%all-true '(34 hallo ())")
(pr (all-true '(34 hallo ())))
