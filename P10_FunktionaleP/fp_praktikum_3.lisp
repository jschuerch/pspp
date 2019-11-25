;; PSPP P09 schuejen
(format t "P10 - Aufgabe 2~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

(load "pspp_basics.lisp")

(defun partial (f &rest args)
  (lambda (&rest more-args)
    (apply f (append args more-args))))

(setfun three-times (partial #'* 3))
(pr "(three-times 6)")
(prRes (three-times 6))

(setfun product (partial #'* 3 14))
(pr "(product)")
(prRes (product))

;
(defun factorial (n &optional (fact 1))
  (if (<= n 1) fact
    (factorial (- n 1) (* n fact))))

(pr "(factorial 5)")
(prRes (factorial 5))

(pr "(factorial 5 10)")
(prRes (factorial 5 10))

; End-Rekursiv: wenn die letzte Anweisung der Funktion der Rekursionsaufruf ist
; Das Zweite Argument rechnet bereits teil der Lösung aus, so dass der rückgabe parameter nicht mehr multipliziert werden muss.

(defun factorial-part (n &optional (fact 1))
  (if (<= n 1) fact
    (partial #'factorial-part (- n 1) (* n fact))))

(pr "(funcall (funcall (factorial-part 3)))")
(prRes (funcall (funcall (factorial-part 3))))

(defun trampoline (fun &rest args)
  (let ((result (apply fun args)))
    (loop while (functionp result) do
      (setq result (funcall result)))
    result))

(pr "(trampoline #'factorial-part 5)")
(prRes (trampoline #'factorial-part 5))

;
