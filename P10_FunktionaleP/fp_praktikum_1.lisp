;; PSPP P09 schuejen
(format t "P10 - Aufgabe 1~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

;;
;; Some fragments for the PSPP exercises
;; Functional Programming (1)
;; (more in pspp_basics.lisp)
;;

;; funktionsdefinition
; (setfun name (lambda (...) ...))
; (defun name (...) ...)

(load "pspp_basics.lisp")

;; range
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
;;


(defmacro setfun (symb fun)
    `(prog1 ',symb (setf (symbol-function ',symb) ,fun)))


(defun repeat (times value)
  (mapcar (lambda (n) value)
          (range times)))

(pr "repeat 5 'hello")
(prRes (repeat 5 'hello))



(defun repeatedly (times fun)
  (mapcar fun (range times)))

(pr "repeatedly 5 (lambda (x) 'hallo)")
(prRes (repeatedly 5 (lambda (x) 'hallo)))

(pr "repeatedly 5 (lambda (x) (1+ (random 6)))")
(prRes (repeatedly 5 (lambda (x) (1+ (random 6)))))

(pr "repeatedly 5 (lambda (n) (concatenate 'string \"id\" (write-to-string n)))")
(prRes (repeatedly 5 (lambda (n) (concatenate 'string "id" (write-to-string n)))))


;(defun always (x) x)
;(setfun always (lambda (&REST R) 42))
;(setfun always (lambda (x) x))

(defun always (val) (lambda (&rest r) val)) ;; Dies is eine Closure

(pr "(always 42)")
(prRes (always 42))

(setfun answer (always 42))

(pr "(answer)")
(prRes (answer))

(pr "(answer nil \"?\" :ok)")
(prRes (answer nil "?" :ok))

(pr "(answer \"was söll das!?\")")
(prRes (answer "was söll das!?"))


(pr "(repeatedly 5 (always 'hello))")
(prRes (repeatedly 5 (always 'hello)))


; Ja, Eine Closure wird für die always funktion verwendet
; Ja, always ist eine Funktion höherer Ordnung, da sie eine Funktion zurückgibt


(setfun num (dispatch #'parse-int #'parse-float #'identity))


(defun num-args (&rest args)
  (mapcar #'num args))



(defun partial (f &rest args)
  (lambda (&rest more-args)
    (apply f (append args more-args))))


(defun factorial (n &optional (fact 1))
  (if (<= n 1) fact
      (factorial (- n 1) (* n fact))))


(defun trampoline (fun &rest args)
  (let ((result (apply fun args)))
    (loop while (functionp result) do
      (setq result (funcall result)))
    result))
