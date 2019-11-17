(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

(pr "Beispiel siite 27")

(defun make-obj (typ farbe laenge)
  (list (list :typ typ)
        (list :farbe farbe)
        (list :laenge laenge)))

(defun get-farbe (obj)
  (second (assoc :farbe obj)))

(defvar *objects* (list (make-obj 'wuerfel 'rot 5)
    (make-obj 'wuerfel 'gelb 10)
    (make-obj 'wuerfel 'blau 8)))

(prRes (mapcar #'get-farbe *objects*))

(prRes (mapcar #'length *objects*))



(pr "member siite 28")

(defvar *farben* '(rot gruen blau))

(prRes (member 'gruen *farben*))
(prRes (member 'lila *farben*))

(prRes (member 'lila *farben* :test #'equal))

(defun alwaystrue (&rest args) t)

(prRes (member 42 *farben* :test #'alwaystrue))



(pr "apply/funcall siite 44")

(defun erstezwei (func obj)
  (funcall func (first obj) (second obj)))

(prRes (erstezwei #'list '(1 2 3 4)))
(prRes (erstezwei #'+ '(1 2 3 4)))



(pr "lambda siite 46")

(prRes (lambda (arg) (+ arg 1)))

(prRes ((lambda (arg) (+ arg 1)) 5))

(prRes (mapcar (lambda (arg) (+ (* arg 2) 1)) '(3 4 5)))




;
