;; PSPP P08 schuejen
;; Aufgabe 3
(format t "Aufgabe 3 - Funktionen mit map-list~%")
; Formatted print
(defun pr (val) (format t "~%--> ~s~%" val))

; execute specified function on every item from list
(defun map-list (f lst)
  (if (null lst) nil
    ;; else
    (cons (funcall f (car lst))
      (map-list f (cdr lst)))))
;; Rekursion is in der letzten Zeile, funcall ruft die funktion auf, welche in f definiert ist

; return sign of number
(defun sign (n)
  (if (> n 0)
    1
    (if (= n 0)
      0
      -1)))

; return squared number
(defun sqr (n)
  (* n n))

; return doubled number
(defun dopplet (n)
  (* n 2))

; test code
;(print 'map-list_sign)
;(pr (map-list #'sign '(5 2 -3 -1 0 3 -2)))


; double every item using map-list
(defun list-double(lst)
  (map-list #'dopplet lst))

(format t "~%list-double '(1 2 3 4)")
(pr (list-double '(1 2 3 4)))


; square every item using map-list
(defun list-sqr(lst)
  (map-list #'sqr lst))

(format t "~%list-sqr '(1 2 3 4)")
(pr (list-sqr '(1 2 3 4)))


; get sign of every item using map-list
(defun list-sign(lst)
  (map-list #'sign lst))

(format t "~%list-sign '(5 2 -3 -1 0 3 -2)")
(pr (list-sign '(5 2 -3 -1 0 3 -2)))
