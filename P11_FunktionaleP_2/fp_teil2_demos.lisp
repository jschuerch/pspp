;; 
;; FUNKTIONALE PROGRAMMIERUNG VERTIEFUNG
;; (PSPP HS19)
;;

;; HINWEIS:
;; einige der folgenden Ausdrücke setzen voraus, dass die Funktionssammlung
;; pspp_basics.lisp geladen ist


;; Iterate-Abstraktion
;; ===================

;; mehrfache Funktionsausführung
(defun iterate (fn init count &optional res)
  (let ((res (if (null res) (list init) res)))
    (cond ((<= count 0) (reverse res))
          (t (iterate fn init (- count 1) (cons (funcall fn (car res)) res))))))

(iterate #'list 0 5)
; --> (0 (0) ((0)) (((0))) ((((0)))) (((((0))))))

(iterate #'1+ 0 20)
; --> (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)

(iterate (lambda (n) (* 2 n)) 1 16)
; --> (1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536)


;; einfache Variante von range mit iterate
(defun simple-range (n)
  (butlast (iterate (lambda (curr) (+ curr 1)) 0 n)))

;; range mit iterate
(defun range (from &optional to (step 1))
  (cond ((null to) (range 0 from 1))
        (t (butlast (iterate (lambda (curr) (+ curr step)) from 
                             (ceiling (/ (- to from) step)))))))

(range 5 10)
; --> (5 6 7 8 9)
(range 0 -10 -1)
; --> (0 -1 -2 -3 -4 -5 -6 -7 -8 -9)

;; Liste der Fibonacci-Zahlen auf verschiedene Weise erstellen

;; herkömmliche rekursive Lösung
(defun fibolist (n &optional (seq '(1 0))) 
  (cond ((<= n 0) (list 0))
        ((= n 1)  (reverse seq))
        (t (fibolist (- n 1) (cons (+ (first seq) (second seq)) seq)))))

;; aus einem Tupel zweier aufeinanderfolgender Zahlen das nächste Tupel
;; bestimmen
(defun nextfib (pair) 
  (cons (cdr pair) 
        (+ (car pair) (cdr pair))))

(nextfib '(1 . 1))
; --> (1 . 2)
(nextfib '(1 . 2))
; --> (2 . 3)
(nextfib '(2 . 3))
; --> (3 . 5)

;; und nun über nextfib iterieren
(iterate #'nextfib '(0 . 1) 5)
; --> ((0 . 1) (1 . 1) (1 . 2) (2 . 3) (3 . 5) (5 . 8))

(mapcar #'car (iterate #'nextfib '(0 . 1) 20))
; --> (0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765)


;; Die Funktion iterate ist in Clojure bereits definiert, ebenso wie die
;; Funktion range, wobei (range) alle Zahlen beginnend bei 0 liefert

; $ clj
; Clojure 1.8.0

; user=> (range 5)
; --> (0 1 2 3 4)

; user=> (take 10 (range))
; --> (0 1 2 3 4 5 6 7 8 9)

; user=> (take 10 (iterate (fn [n] (+ n 1)) 0))
; --> (0 1 2 3 4 5 6 7 8 9)

; user=> (defn fib-pair [ [a b] ]  [b (+ a b)])
; --> #'user/fib-pair

; user=> (fib-pair [3 5])
; --> [5 8]

; user=> (take 20 (map first (iterate fib-pair [0 1])))
; --> (0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181)


;; Vollkommene Zahlen
;; ==================

(defun is-factor (factor number)
  (= (rem number factor) 0))

(defun get-factors-for (number)
  (remove-if-not (lambda (n) (is-factor n number))
                 (range 2 number)))

(defun is-perfect (number)
  (= (reduce #'+ (cons 1 (get-factors-for number)))
     number))

(defun generate-perfect-numbers (from to)
  (remove-if-not #'is-perfect (range from to)))

(generate-perfect-numbers 0 1000)
; --> (1 6 28 496)


;; Memoize
;; =======

;; erstellt Version einer Funktion, die bereits berechnete Werte in einer
;; Hashtabelle zwischenspeichert (sehr vereinfacht und nicht in jeder
;; Situation gut geeignet)
(defun memoize (fn)
  (let ((cache (make-hash-table :test #'equal)))
    (lambda (&rest args)
      (multiple-value-bind (val win) (gethash args cache)
        (if win val
            ;; else
            (setf (gethash args cache)
                  (apply fn args)))))))

;; Optimierung in CCL ausschalten, damit Effekt sichtbar wird
(declaim (optimize (debug 3)))

;; zum Test des Memoizers: n-te Fibonacci-Zahl
(defun fibo (n) 
  (cond ((< n 2) n)
        (t (+ (fibo (- n 1)) (fibo (- n 2))))))


(time (fibo 40))
; --> took 767,440 microseconds (0.767440 seconds) to run.

(setfun fibo (memoize #'fibo))
; --> FIBO

(time (fibo 40))
; --> took 33 microseconds (0.000033 seconds) to run.


;; Objekte als Werte (JS)
;; ======================

; > const incr = (n) => n+1
; undefined
; 
; > incr(33)
; 34
; 
; > const incrAge = (p) => ({ ...p, age: p.age+1 })
; undefined
; 
; > incrAge({ name: "Paul", age: 33 })
; { name: 'Paul', age: 34 }


