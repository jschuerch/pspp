;; PSPP P11 schuejen
(format t "P11 - Aufgabe 1~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

(load "pspp_basics.lisp")

;; erster aufgaben-block ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; with-input-from-string: erstellt einen string stream und führt darauf Operationen aus.
; 		in diesem Fall wird ein json-string in json decodiert
; Welche Datentypen werden verwendet? Welche Bezeichnungen wurden geändert?
;		JSON daten wurden in assoc-liste umgewandelt. 
;		keywords-string werden in keyword parameter umgewandelt "result" --> :result 

;; read tasks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *tasks-list* (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream)))
;(pr (cdar *tasks-list*))

; fake the read-json function :P
(defun read-json (file)
 (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream)))
;(pr (read-json "tasks.json"))


;; getprop-fn ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defun getprop-fn (key lst)
;  (cond ((null lst) nil)
;    ((equal (caar lst) key) (cdar lst))
;    (t (getprop-fn key (cdr lst)))
;    ))

(defun getprop-fn (key list)
  (cdr (assoc key list)))

(pr "getprop-fn :result ...")
(prRes (getprop-fn :result '((:RESULT . "SUCCESS") (:INTERFACE-VERSION . "1.0.3"))))

(pr "getprop-fn :result *tasks-list*")
(prRes (getprop-fn :result *tasks-list*))


;; getprop with curry ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun curry (f numargs)
  (lambda (&rest args)
    (if (>= (length args) numargs)
      (apply f args)
      (curry
        (lambda (&rest restargs) (apply f (append args restargs)))
        (- numargs (length args))))))

(defmacro setfun (symb fun)
    `(prog1 ',symb (setf (symbol-function ',symb) ,fun)))

(setfun getprop (curry #'getprop-fn 2))

(pr "getprop :result ...")
(prRes (getprop :result '((:RESULT . "SUCCESS") (:INTERFACE-VERSION . "1.0.3"))))

(pr "getprop :result *tasks-list*")
(prRes (getprop :result *tasks-list*))


;; save tasks to *tasks* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(pr "(getprop :tasks (read-json ''tasks.json''))")
;(prRes (getprop :tasks (read-json "tasks.json"))) ;; returns the tasks

;(pr "(getprop :tasks)")
;(prRes (getprop :tasks)) ;; returns a closure/function

(pr (defvar *tasks* (getprop :tasks (read-json "tasks.json"))))


;; filter & reject ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; holt die elemente welche mit f nil zurückliefern
; bzw. welche dem filter kriterium entsprechen
(defun filter-fn (f seq)
  (remove-if-not f seq))

(setfun filter (curry #'filter-fn 2))

(pr "filter-fn")
(prRes (filter-fn #'zerop '(2 5 0 2 4 0)))
(pr "filter")
(prRes (filter #'zerop '(2 5 0 2 4 0)))

; holt die elemente welche mit f nicht nil zurückliefern
; bzw. welche dem filter kriterium NICHT entsprechen
(defun reject-fn (f seq)
  (remove-if f seq))

(setfun reject (curry #'reject-fn 2))

(pr "reject-fn")
(prRes (reject-fn #'zerop '(2 5 0 2 4 0)))

(pr "reject")
(prRes (reject #'zerop '(2 5 0 2 4 0)))


;; prop-eq ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; eine pipeline schaltet mehrere Funktionen hintereinander. Dabei wird der
; Rückgabeparemeter der ersten Funktion ein Parameter der 2. Funktion.
; da getprop curryfiziert ist und die 2. funktion ebenfalls eine partial funktion ist,
; nehme ich an, dass eine art funktion zurück gegeben wird, welche noch einen
; übergabeparameter (eine Liste) erwartet, von welcher alle einträge mit dem
; property-value = val zurückgegeben wird
(defun prop-eq (prop val)
  (pipeline (getprop prop) (partial #'equal val)))

(pr "prop-eq")
(prRes (prop-eq :member "Scott"))


(pr "(filter (prop-eq :member ''Scott'') *tasks*)")
(prRes (filter (prop-eq :member "Scott") *tasks*))

(pr "(filter (prop-eq :member ''Scott''))")
(prRes (filter (prop-eq :member "Scott")))


;; pick ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; pick gibt eine Datnstruktur zurück welche nur dijenigen elemente aus obj
; enthalten welche das attribut in attrs enthält
(defun pick-fn (attrs obj)
  (remove-if-not #'(lambda (el) (member (car el) attrs)) obj))

(setfun pick (curry #'pick-fn 2))

(setfun forall (curry #'mapcar 2))

(pr "pick")
(prRes (forall (pick '(:due-date :title)) *tasks*))


;; date-to-universal ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; string-split in pspp_basics eingefügt (aus praktikum 9)
;(pr (string-split #\/ "11/15/2013"))

;(defun date-to-universal (date)
;  (set 'a (mapcar #'parse-integer (string-split #\/ date)))
;  (encode-universal-time 0 0 0 (second a) (car a) (caddr a) 0))

(defun date-to-universal (date)
  (multiple-value-bind (m d y)
    (values-list (mapcar #'parse-integer (string-split #\/ date)))
    (encode-universal-time 0 0 0 d m y 0)
    ))

(pr "date-to-universal ''11/15/2013''")
(prRes (date-to-universal "11/15/2013"))


(defun sort-by-fn (f seq)
  (sort (copy-list seq)
    (lambda (a b) (< (funcall f a) (funcall f b)))))

(setfun sort-by (curry #'sort-by-fn 2))

;; open-tasks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun open-tasks (name)
  (pipeline
    (getprop :tasks)
    (filter (prop-eq :member name))
    (reject (prop-eq :complete t))
    (forall (pick '(:id :due-date :title :priority)))
    (sort-by (pipeline (getprop :due-date) #'date-to-universal))))

(pr "(funcall (open-tasks 'Scott') *tasks-list*")
(prRes (funcall (open-tasks "Scott") *tasks-list*))

(pr "(funcall (open-tasks 'Lena') *tasks-list*")
(prRes (funcall (open-tasks "Lena") *tasks-list*))

;
