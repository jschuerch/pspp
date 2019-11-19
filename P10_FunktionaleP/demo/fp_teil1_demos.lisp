;; 
;; FUNKTIONALE PROGRAMMIERUNG EINFUEHRUNG
;; (PSPP HS19)
;;

;; HINWEIS:
;; einige der folgenden Demos setzen voraus, dass die Funktionssammlung
;; pspp_basics.lisp geladen ist


;; apply vs funcall
;; ================
(funcall (first '(+ - * /)) 12 5)
(apply (second '(+ - * /)) '(12 5))


;; Funktionen als Parameter
;; ========================

;; Mapping 
;; Hier wird die eigene Implementierung map-list verwendet, obwohl in 
;; Common Lisp bereits eine Funktion mapcar existiert
(map-list #'1+ '(1 2 3 4 5))

;; Mapping mit Lambda
(map-list (lambda (n) (cons n n)) 
          '(1 2 3 4 5))

;; member
;; der vordefinierten Funktion member kann eine Testfunktion übergeben werden
(member 5 '(16 25 36) :test (lambda (m n) (= (* m m) n)))

;; eine Liste für ein paar Tests
(defvar *friends* '(((:name . "Peter") (:age . 32)) 
                    ((:name . "Eva") (:age . 29)) 
                    ((:name . "Maria") (:age . 30))))

;; sort verändert die Liste destruktiv, daher wird zunächst eine top-level-
;; Kopie der Liste hergestellt
(sort (copy-list *friends*) 
      (lambda (a b) 
        (<= (cdr (assoc :age a)) 
            (cdr (assoc :age b)))))

;; alternativer Aufruf
(sort (copy-list *friends*) #'<= 
      :key (lambda (el) (cdr (assoc :age el))))

;; Liste filtern
(filter-list #'(lambda (n) (<= 10 n)) '(4 23 1 12 -22 73))

;; Variante (Vorschau, später mehr in der Art)
(filter-list (partial #'<= 10) '(4 23 1 12 -22 73))


;; Listen reduzieren
;; =================

;; von links oder rechts reduzieren
;; Haskell: foldl, foldr
(reduce-list #'list '(1 2 3 4))
(reduce-list-right #'list '(1 2 3 4))

;; reduce einsetzen: best-Funktion
(defun best (fun coll)
  (reduce-list (lambda (x y) (if (funcall fun x y) x y))
               (car coll)
               (cdr coll)))

;; Beispiele
(best #'> '(4 8 2 9 3))
(best (lambda (a b) (> (length a) (length b))) '("ab" "abcd" "a"))

;; Liste kopieren
(reduce-list-right #'cons  nil '(5 2 5 7 8 2 4))

;; Mapping mit reduce
(reduce-list-right 
  (lambda (next res) (cons (* 2 next) res)) 
  nil 
  '(5 2 5 7 8 2 4))

;; Filtern mit reduce
(reduce-list-right 
  (lambda (next res) (if (evenp next) (cons next res) res))   nil 
  '(5 2 5 7 8 2 4))


;; Funktionen als Rückgabewert
;; ===========================

(setfun ++ (splat #'+))
(++ '(1 2 3))
(setfun add (unsplat (splat #'+)))
(add 1 2 3)

;; Unterschied defun, setfun
(defun incr (n) (+ n 1))
(setfun incr (lambda (n) (+ n 1)))

;; Function Wrapper
;; ----------------
(defun wrap-fn (f pre &optional (post #'identity))
    (lambda (&rest args)
        (cond ((equal args '(:orig)) f)
              (t (funcall post (apply f (apply pre args)))))))

;; ein paar Hilfsfunktionen (definiert in pspp_basics.lisp)
(print-args 1 2 3)
(print-res 42)
(defaults 11 22 33)
(apply (defaults 11 22 33) '(1 Nil 3))

;; Funktion dekorieren
(rem 7 4) ; remainder
(setfun rem-pr (wrap-fn #'rem #'print-args #'print-res))
(rem-pr 7 4)
(setfun rem-pr-def (wrap-fn #'rem-pr (defaults 1 1)))
(rem-pr-def 7 4)
(rem-pr-def 3)
(rem-pr-def)

;; ursprüngliche Funktion wieder auspacken
(setfun rem-pr-nodef (rem-pr-def :orig))
(rem-pr-nodef 7 4)
(setfun rem-orig (rem-pr-nodef :orig))
(rem-orig 7 4)


;; Function Dispatcher
;; -------------------
;; es wird eine neue Funktion erzeugt, die aus einer Liste von Funktionen
;; eine nach der anderen aufruft, bis eine non-Nil zurückgibt 
(defun dispatch (&rest funcs)
  (lambda (&rest args)
      (if (null funcs) nil
          ;; else
          (let ((result (apply (car funcs) args)))
            (if result result
                ;; else
                (apply (apply #'dispatch (cdr funcs)) args))))))

;; String ohne das letzte Zeichen
(defun string-butlast (s)
    (if (stringp s)
        (subseq s 0 (- (length s) 1))))

;; Liste ohne das letzte Element
(defun list-butlast (l)
    (if (listp l)
        (butlast l)))

(setfun gen-butlast (dispatch #'list-butlast #'string-butlast))
(gen-butlast "abc")
(gen-butlast '(1 2 3))
(gen-butlast :oh)

(always 12)
(setfun silly-butlast (dispatch #'gen-butlast (always 42)))
(silly-butlast '(1 2 3))
(silly-butlast :oh)


;; Partielle Anwendung und Currying
;; ================================

;; partial
(member 0 '(1 2 3))
(setfun zero-in-list (partial #'member 0))

(zero-in-list '(1 2 3))
(zero-in-list '(-1 0 1 2))

;; Currying
(setfun gt (curry2r #'>))
(setfun lt (curry2r #'<))
(funcall (gt 5) 7)

(setfun in-range (checker (gt 5) (lt 15)))
(in-range 10)

(setfun in-range-and-even (checker #'in-range #'evenp))
(in-range-and-even 7)
(in-range-and-even 8)

;; modifizierte reduce-Funktion
(setfun reduce-c (curry #'reduce-list-right 3))

(reduce-c #'list nil '(1 2 3 4 5))
; (1 (2 (3 (4 (5 NIL)))))
(reduce-c #'list nil)
; #<COMPILED-LEXICAL-CLOSURE (:INTERNAL AUTOCURRY) #x30200111ED2F>
(funcall (reduce-c #'list nil) '(1 2 3 4 5))
; (1 (2 (3 (4 (5 NIL)))))

;; damit elegante neue Funktionsdefinitionen möglich, ohne die Liste als Parameter
;; angeben zu müssen
(setfun sum-list (reduce-c #'+ 0))
(setfun mult-list (reduce-c #'* 1))
(setfun all-true (reduce-c (lambda (a b) (and a b)) t))
(setfun top-level-copy (reduce-c #'cons nil))

;; Test der Funktionen
(sum-list '(1 2 3 4 5))
(mult-list '(1 2 3 4 5))
(top-level-copy '(1 2 3))


;; Funktion ausführen und vorne in Liste einfügen
(defun f-and-cons (fn)
  (lambda (arg1 seq) 
    (cons (funcall fn arg1) seq)))

(f-and-cons #'1+)
; --> <function>

(funcall (f-and-cons #'1+) 1 '(2 3))
; --> (2 2 3)

;; mit f-and-cons und reduce-c kann eine curryfizierte map-Funktion 
;; erstellt werden:
(defun map-list-c (f) (reduce-c (f-and-cons f) nil))

(map-list-c #'1+)
; --> #<COMPILED-LEXICAL-CLOSURE (:INTERNAL AUTOCURRY) #x302000F3ED4F>

(funcall (map-list-c #'1+) '(1 2 3 4 5))
; --> (2 3 4 5 6)

; In Miranda kann man map auf ähnliche Weise, aber deutlich einfacher, definieren
; (dabei ist "." die Funktionsverkettung, erst f dann Cons):
; 
; map f = foldr (Cons . f) Nil


;; Komposition und Pipeline
;; ========================

;; Funktionen verketten
(defun compose-simple (f g) 
  (lambda (&rest args) 
    (funcall f (apply g args))))


;; SCHWIERIGE FRAGE:
;; Kann f-and-cons mit compose-simple ausgedrückt werden?
;; --> Wann ja: wie?
;; --> Wenn nein: warum nicht?


;; Pipeline: Funktion aus Verkettung von Funktionen bilden 
;;
(defun pipeline (&rest funcs)
  (lambda (&rest args)
    (car (reduce
           (lambda (ar f) (list (apply f ar)))
           funcs
           :initial-value args))))

;; Hilfsfunktion
(defun double (n) (* 2 n))

; ??
(pipeline #'double #'1+)

; ??
(funcall (pipeline #'double #'1+ #'double) 10)


;; map and concatenate
(setfun mapcat (pipeline #'mapcar (splat #'append)))
(mapcat (lambda (n) (cons n '(","))) '(1 2 3))

;; Funktionen aus bestehenden Funktionen zusammensetzen 
(defun switch-params (f)
  (lambda (a b) (funcall f b a)))

(setfun what-a (pipeline (partial #'* 2) (partial #'+ 1)))
(setfun what-b (pipeline (partial (switch-params #'mod) 2) #'zerop))

;; oder ohne switch-params
(setfun what-b (pipeline (funcall (curry2r #'mod) 2) #'zerop))


;; Rekursion und partielle Anwendung
;; =================================

;; partial
(sqrt 2)
(partial #'sqrt 2)

(setfun sqrt2 (partial #'sqrt 2))
(sqrt2)

;; diese Funktionen rufen sich gegenseitig auf
(defun even-rec (n) 
  (if (zerop n) t
      (odd-rec (- (abs n) 1))))

(defun odd-rec (n)
  (if (zerop n) nil
      (even-rec (- (abs n) 1))))

;; in manchen Lisp-Installationen liefert das einen Stack-Überlauf
(even-rec 10000)

;; Abhilfe: Aufruf verzögern mit partieller Anwendung
(defun partial (f &rest args)
  (lambda (&rest more-args)
    (apply f (append args more-args))))

(defun even-part (n)
  (if (zerop n) t
      (partial #'odd-part (- (abs n) 1))))

(defun odd-part (n)
  (if (zerop n) nil
      (partial #'even-part (- (abs n) 1))))

(odd-part 3)
(funcall (odd-part 3))
(funcall (funcall (odd-part 3)))
(funcall (funcall (funcall (odd-part 3))))

;; offene Aufrufe ausführen bis keine neue Funktion mehr resultiert
(defun trampoline (fun &rest args)
  (let ((result (apply fun args)))
    (loop while (functionp result) do 
      (setq result (funcall result)))
    result))

;; Beispiel
(trampoline #'even-part 10000)


