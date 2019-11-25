;; PSPP P09 schuejen
(format t "P10 - Aufgabe 2~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

(load "pspp_basics.lisp")

(setfun num (dispatch #'parse-int #'parse-float #'identity))

(defun num-args (&rest args)
  (mapcar #'num args))

;

(pr "num ''NaN''")
(prRes (num "NaN"))

(pr "num :a")
(prRes (num :a))

(pr "num ''13''")
(prRes (num "13"))

(pr "num 13")
(prRes (num 13))

(pr "num ''14.3''")
(prRes (num "14.3"))

(pr "num 14.3")
(prRes (num 14.3))

(pr "num '(12 3)")
(prRes (num '(12 3)))

; Gibt einen Integer zurück wenn der Parameter eine ganze Zahl enthält,
; Gibt einen Float zurück wenn der Parameter eine Fliesskommazahl enthält (als String oder Zahl)
; Ansonsten wird der Parameter zurück gegeben (--> Identity, fallback wenn parsen nicht funktioniert hat)

;
(setfun add (wrap-fn #'+ #'num-args))

(pr "add 12 3 5")
(prRes (add 12 3 5))

(pr "add 12 \"3\" \"5.5\" 2")
(prRes (add 12 "3" "5.5" 2))

; Wenn der add-Funktion etwas anderes wie ein String übergeben wird, wirft die Funktion einen Fehler.
; --> wenn Parameter keine Zahl ist eine 0 zurückgeben.
(setfun num-mod (dispatch #'parse-int #'parse-float (lambda (x) (if (numberp x) x 0))))

(defun num-args-mod (&rest args)
  (mapcar #'num-mod args))

(setfun add-mod (wrap-fn #'+ #'num-args-mod))

(pr "num-args-mod 12 \"3\" \"a\" \"5.5\" 2.3")
(prRes (num-args-mod 12 "3" "a" "5.5" 2.3))

(pr "add-mod 12 \"3\" \"a\" \"5.5\" 2.3")
(prRes (add-mod 12 "3" "a" "5.5" 2.3))

;
