;; PSPP P09 schuejen
(format t "Snippets aus Folien~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))


(defun filter-list (f seq)
  (cond ((null seq) nil)
        ((funcall f (car seq))
            (cons (car seq) (filter-list f (cdr seq))))
        (t (filter-list f (cdr seq)))))

(pr "(filter-list (lambda (n) (> n 10)) '(4 23 1 12 -22 73))")
(prRes (filter-list (lambda (n) (> n 10)) '(4 23 1 12 -22 73)))

(pr "(reduce #'+ '(3 22 1))")
(prRes (reduce #'+ '(3 22 1)))

(pr "(reduce #'list '(1 2 3 4))")
(prRes (reduce #'list '(1 2 3 4)))

(pr "(reduce #'list '(1 2 3 4) :from-end t)")
(prRes (reduce #'list '(1 2 3 4) :from-end t))

(pr "(reduce #'list '(1 2 3 4) :initial-value 99)")
(prRes (reduce #'list '(1 2 3 4) :initial-value 99))

(pr "(reduce #'list '(1 2 3 4) :from-end t :initial-value 99)")
(prRes (reduce #'list '(1 2 3 4) :from-end t :initial-value 99))

(defun reduce-list (f init seq)
  (cond ((null seq) init)
        (t (funcall f (car seq) (reduce-list f init (cdr seq))))))

(defun alltrue (seq)
  (reduce-list (lambda (a b) (and a b)) t seq))
;  (reduce (lambda (a b) (and a b)) seq :initial-value t))

(pr "(alltrue '(1 () 3 4))")
(prRes (alltrue '(1 () 3 4)))


(defun best (fun coll)
  (reduce-list (lambda (x y) (if (funcall fun x y) x y))
                (car coll) (cdr coll)))

(pr "(best #'> '(4 8 2 9 3))")
(prRes (best #'> '(4 8 2 9 3)))

(pr "(best (lambda (a b) (> (length a) (length b))) '(\"ab\" \"abcd\" \"a\"))")
(prRes (best (lambda (a b) (> (length a) (length b))) '("ab" "abcd" "a")))

(pr "(reduce-list #'cons nil '(5 2 5 7 8 2 4))")
(prRes (reduce-list #'cons nil '(5 2 5 7 8 2 4)))

(pr "(reduce-list (lambda (next res) (cons (* 2 next) res)) nil '(5 2 5 7 8 2 4))")
(prRes (reduce-list (lambda (next res) (cons (* 2 next) res)) nil '(5 2 5 7 8 2 4)))

(pr "(reduce-list (lambda (next res) (if (evenp next) (cons next res) res)) nil '(5 2 5 7 8 2 4))")
(prRes (reduce-list (lambda (next res) (if (evenp next) (cons next res) res)) nil '(5 2 5 7 8 2 4)))


(defun splat (f) (lambda (arglist) (apply f arglist)))
(defun unsplat (f) (lambda (&rest args) (funcall f args)))

(pr "(splat #'+)")
(prRes (splat #'+))

(pr "(funcall (splat #'+) '(5 6))")
(prRes (funcall (splat #'+) '(5 6)))

(pr "(length '(3 5 6 7))")
(prRes (length '(3 5 6 7)))

(pr "(funcall #'length '(3 5 6 7))")
(prRes (funcall #'length '(3 5 6 7)))

(pr "(funcall (unsplat #'length) 1 9 5 6 7)")
(prRes (funcall (unsplat #'length) 1 9 5 6 7))


(defmacro setfun (symb fun)
    `(prog1 ',symb (setf (symbol-function ',symb) ,fun)))

(setfun length_s (unsplat #'length))
(pr "(length_s 3 5 6 7 8)")
(prRes (length_s 3 5 6 7 8))


(pr (defun adder (x) (lambda (y) (+ x y))))   ;; Closure
; ???? A closure is a type of Lisp functional object useful for implementing certain
; advanced access and control structures. Closures give you more explicit control
; over the environment by allowing you to save the dynamic bindings of specified
; variables and then to refer to those bindings later, even after the construct
; (let, etc.) which made the bindings has been exited.
(pr (setfun add5 (adder 5)))
(pr "(add5 1024)")
(prRes (add5 1024))

(defun wrap-fn (f pre &optional (post (lambda (arg) arg)))
  (lambda (&rest args)
    (cond ((equal args '(:orig)) f)
      (t (funcall post (apply f (apply pre args)))))))

;; Hilfsfunktionen:
(defun print-args (&rest args)
  (format t "Called with args ~S~%" args) args)

(defun print-res (res)
  (format t "Result: ~S~%" res) res)

(setfun add (wrap-fn #'+ #'print-args #'print-res))
(pr "(add 4 3) ; mit wrap-fn sache")
(prRes (add 4 3))


(defun defaults (&rest def)
  (lambda (&rest args)
    (merge-defaults args def)))

(defun merge-defaults (seq defaults)
  (if (null defaults) seq
    (cons (if (or (null seq) (null (car seq))) (car defaults) (car seq))
      (merge-defaults (cdr seq) (cdr defaults)))))

(defun range-simple (a b c)
  (cond ((>= a b) nil)
    (t (cons a (range-simple (+ a c) b c)))))

(pr "(range-simple 0 10 3)")
(prRes (range-simple 0 10 3))

(setfun range-simple (wrap-fn #'range-simple (defaults 0 0 1)))

(pr "(range-simple 0 10)")
(prRes (range-simple 0 10))

(pr "(range-simple 0 10 4)")
(prRes (range-simple 0 10 4))

(setfun range-simple (range-simple :orig)) ;; Defaults entfernt
;(pr "(range-simple 0 10)")
;(prRes (range-simple 0 10)) ;das git dänn en Fehler


(defun compl (f)
  (lambda (&rest args)
    (not (apply f args))))

(defun is-even (n)
  (zerop (mod n 2)))

(setfun is-odd
  (complement #'is-even))
;  (compl #'is-even))


(pr "(is-odd 3)")
(prRes (is-odd 3))
(pr "(is-even 3)")
(prRes (is-even 3))


;; use first function that returns something
(defun dispatch (&rest funcs)
  (lambda (&rest args)
    (if (null funcs) nil
      ;; else
      (let ((result (apply (car funcs) args)))
        (if result result
          ;; else
          (apply (apply #'dispatch (cdr funcs)) args))))))

;; just for demonstration purposes
(defun string-butlast (s)
  (if (stringp s) (subseq s 0 (- (length s) 1))))
(defun list-butlast (l)
  (if (listp l) (butlast l)))

(setfun gen-butlast (dispatch #'list-butlast #'string-butlast))

(pr "(gen-butlast \"abc\")")
(prRes (gen-butlast "abc"))

(pr "(gen-butlast '(1 2 3))")
(prRes (gen-butlast '(1 2 3)))

(pr "(gen-butlast :oh)")
(prRes (gen-butlast :oh))


(defun always (val) (lambda (&rest r) val))
(setfun silly-butlast (dispatch #'gen-butlast (always 42)))

(pr "(silly-butlast '(1 2 3 4 5))")
(prRes (silly-butlast '(1 2 3 4 5)))

(pr "(silly-butlast :oh)")
(prRes (silly-butlast :oh))


(defun partial (f &rest args)
  (lambda (&rest more-args)
    (apply f (append args more-args))))

;; Hilfsfunktionen
(defun || (a b) (or a b))
(defun && (a b) (and a b))

;; anytrue mit Hilfe von reduce-list
(defun anytrue (seq)
  (reduce-list #'|| nil seq))

;; anytrue mit Hilfe von partial und reduce-list
;; (die ersten beiden Parameter werden festgelegt)
(setfun anytrue (partial #'reduce-list #'|| nil))

(setfun alltrue (partial #'reduce-list #'&& t))
(setfun sum-list (partial #'reduce-list #'+ 0))
(setfun mult-list (partial #'reduce-list #'* 1))
(setfun copy-list-elems (partial #'reduce-list #'cons nil))

(pr "anytrue")
(prRes (anytrue '(2 () () 23 4)))
(prRes (anytrue '(() () 23 4)))
(prRes (anytrue '(() () ())))

(pr "alltrue")
(prRes (alltrue '(2 () 23 4)))
(prRes (alltrue '(2 34 23 4)))

(pr "sum-list")
(prRes (sum-list '(2 3 4)))

(pr "mult-list")
(prRes (mult-list '(2 3 4)))

(pr "copy-list-elems")
(prRes (copy-list-elems '(2 3 4)))


;; für Funktion von zwei Argumenten
(defun curry2 (f)
  (lambda (a)
    (lambda (b)
      (funcall f a b))))
;; von rechts
(defun curry2r (f)
  (lambda (b)
    (lambda (a)
      (funcall f a b))))

;; für Funktion von drei Argumenten
(defun curry3 (f)
  (lambda (a)
    (lambda (b)
      (lambda (c)
        (funcall f a b c)))))

;; von rechts
(defun curry3r (f)
  (lambda (c)
    (lambda (b)
      (lambda (a)
        (funcall f a b c)))))

(pr "currying")
(prRes (funcall (funcall (curry2 #'add) 17) 4))

(defun checker (&rest validators)
  (lambda (elem)
    (every (lambda (check) (funcall check elem)) validators)))


(setfun gt (curry2r #'>))

(setfun lt (curry2r #'<))

(setfun in-range (checker (gt 5) (lt 15)))

(pr "in-range")
(prRes (in-range 10))

(setfun in-range-and-even (checker #'in-range #'evenp))

(pr "in-range-and-even")
(prRes (in-range-and-even 7))
(prRes (in-range-and-even 8))
(prRes (in-range-and-even 20))


(defun compose-simple (f g)
  (lambda (&rest args) (funcall f (apply g args))))

(defun doublee (a)
  (* a a))

(pr "(funcall (compose-simple #'doublee #'+) 3 4)")
(prRes (funcall (compose-simple #'doublee #'+) 3 4))

(defun pipeline (&rest funcs)
  (lambda (&rest args)
    (car (reduce
      (lambda (ar f) (list (apply f ar)))
      funcs
      :initial-value args))))

(setfun mapcat (pipeline #'mapcar (splat #'append)))

(pr "(mapcat (lambda (n) (cons n '(\",\"))) '(1 2 3))")
(prRes (mapcat (lambda (n) (cons n '(","))) '(1 2 3)))



(defun switch-params (f)
  (lambda (a b) (funcall f b a)))
(setfun what-a (pipeline (partial #'* 2) (partial #'+ 1)))
(setfun what-b (pipeline (partial (switch-params #'mod) 2) #'zerop))

(pr "(mod 7 4)")
(prRes (mod 7 4))

(pr "(what-a 7)")
(prRes (what-a 7))

(pr "(what-b 45)")
(prRes (what-b 45))

(pr "(what-b 12)")
(prRes (what-b 12))



;
