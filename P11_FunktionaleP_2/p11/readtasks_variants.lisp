(with-open-file (mystream "tasks.lisp" :direction :input) (read mystream))


(set 'tasks (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream)))

;globale variable
(defvar *tasks* (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream)))


oder direkt in funktion
(doSomething (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream)))


(devfun readtasks ()
	(set 'tasks (with-open-file (mystream "tasks.lisp" :direction :input) (read mystream))))
