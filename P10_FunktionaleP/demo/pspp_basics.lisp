;;
;; Common Lisp Additions, V 1.1.2
;; Basics for PSPP Module 
;; ZHAW Winterthur 
;; Gerrit Burkert, 2012-2019
;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MACRO SETFUN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; simplifies binding of a function to 
;; a symbol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro setfun (symb fun)
    `(prog1 ',symb (setf (symbol-function ',symb) ,fun)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LAMBDA READER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; functional programming aficionados:
;; here is a lambda reader macro, now
;; you can use youre preferred symbol
;; λ instead of lambda
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Source:
; https://stackoverflow.com/questions/9557469/renaming-lambda-in-common-lisp
(defun λ-reader (stream char)
  (declare (ignore char stream))
  'LAMBDA)

(set-macro-character #\λ #'λ-reader)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAP, REDUCE, FILTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; contrary to the version shown in the
;; lessons or in the exercises, some of
;; these functions use the pre-defined 
;; Common Lisp functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mapping over a list (aka mapcar)
;; (recursive version)
;;
;(defun map-list (f lst) 
;  (if (null lst) nil
;      ;; else
;      (cons (funcall f (car lst))
;            (map-list f (cdr lst)))))

;; Mapping over a list
;; (iterative version)
;;
(defun map-list (f seq) 
    (loop for el in seq collect (funcall f el)))


;; Reduce list from left
;;
(defun reduce-list-left (fn &rest args)
    (if (eql (length args) 2)
        (reduce fn (second args) :initial-value (first args))
        (reduce fn (first args))))


;; Reduce list from right
;;
(defun reduce-list-right (fn &rest args)
    (if (eql (length args) 2)
        (reduce fn (second args) :initial-value (first args) :from-end t)
        (reduce fn (first args) :from-end t)))


;; Reduce list: aliases
;;
(setfun reduce-list #'reduce-list-left)
(setfun foldl #'reduce-list-left)
(setfun foldr #'reduce-list-right)


;; Filter list with a predicate (aka remove-if-not)
;;
(defun filter-list (f seq) 
  (cond ((null seq) nil) 
        ((funcall f (car seq)) (cons (car seq) (filter-list f (cdr seq)))) 
        (t (filter-list f (cdr seq)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LIST HANDLING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make a list with a sequence of numbers
;; This function is not implemented here because it is part
;; of an exercise
;(defun range (start &optional end (step 1)) ...


;; Merge two lists to an alist
;;
(defun zip-to-alist (lst1 lst2)
  (cond ((or (null lst1) (null lst2)) nil)
        (t (cons (cons (car lst1) (car lst2)) 
                 (zip-to-alist (cdr lst1) (cdr lst2))))))


;; Flatten list structure
;;
(defun flatten (seq)
  (cond ((null seq) nil)
        ((listp (car seq)) 
            (append (flatten (car seq)) (flatten (cdr seq))))
        (t (cons (car seq) (flatten (cdr seq))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLOSURE AND MEMOIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; do something repeatedly
;;
(defun repeatedly (times fun)
  (mapcar fun (range times)))


;; return always the same value
;; This function is not implemented here because it is part
;; of an exercise
;(defun always (val) ...


;; make memoizing version of a function
;;
(defun memoize (fn)
  (let ((cache (make-hash-table :test #'equal)))
    #'(lambda (&rest args)
        (multiple-value-bind (val win) (gethash args cache)
          (if win val
            ;; else
            (setf (gethash args cache)
                  (apply fn args)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CURRYING AND PARTIAL APPLICATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Partial application of a function: return a 
;; function of the remaining arguments
;;
(defun partial (f &rest args)
  (lambda (&rest more-args)
    (apply f (append args more-args))))


;; Curry a function of two arguments
;;
(defun curry2 (f)
  (lambda (a)
    (lambda (b)
      (funcall f a b))))


;; Curry a function of three arguments
;;
(defun curry3 (f)
  (lambda (a)
    (lambda (b)
      (lambda (c)
        (funcall f a b c)))))


;; Curry a function of two arguments (right to left)
;;
(defun curry2r (f)
  (lambda (b)
    (lambda (a)
      (funcall f a b))))


;; Curry a function of three arguments (right to left)
;;
(defun curry3r (f)
  (lambda (c)
    (lambda (b)
      (lambda (a)
        (funcall f a b c)))))


;; Curry a function with numargs parameters: if the resulting 
;; function is called with fewer arguments, a curried function of 
;; the remaining arguments is returned
;;
(defun curry (f numargs)
  (lambda (&rest args)
    (if (>= (length args) numargs)
        (apply f args)
        (curry 
          (lambda (&rest restargs) (apply f (append args restargs)))
          (- numargs (length args))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PARAMETER HANDLING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Change function to accept list with parameters
;;
(defun splat (f)
    #'(lambda (arglist)
        (apply f arglist)))


;; Change function to accept individual parameters 
;; instead of a list
;;
(defun unsplat (f)
    #'(lambda (&rest args)
        (funcall f args)))


;; Switch first two parameters of the function 
;;
(defun switch-params (f) 
    #'(lambda (a b &rest args) 
        (apply f (cons b (cons a args)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTION WRAPPER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Wrap function with pre and (optional) post 
;; processing functions; calling a wrapped 
;; function with argument :orig returns the
;; original function
;;
(defun wrap-fn (f pre &optional (post #'(lambda (arg) arg)))
    #'(lambda (&rest args)
        (cond ((equal args '(:orig)) f)
              (t (funcall post (apply f (apply pre args)))))))


;; Print arguments to console (to be used with wrap-fn)
;;
(defun print-args (&rest args)
    (format t "Called with args ~S~%" args)
    args)


;; Print result to console (to be used with wrap-fn)
;;
(defun print-res (res)
    (format t "Result: ~S~%" res)
    res)


;; Make a function with defaults for its arguments
;; 
(defun defaults (&rest defaults)
    #'(lambda (&rest args)
        (merge-defaults args defaults)))

;; Helper function 
(defun merge-defaults (seq defaults)
    (if (null defaults) seq
        (cons (if (or (null seq) (null (car seq))) (car defaults) (car seq))
              (merge-defaults (cdr seq) (cdr defaults)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTION COMBINATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Simple composition of two functions
;;
(defun compose-simple (f g) 
  #'(lambda (&rest args) 
      (funcall f (apply g args))))


;; Compose two functions and optionally specify the number 
;; of arguments the function called first should consume
;;
(defun compose-funcs (f g &optional npar)
  #'(lambda (&rest args)
      (let ((nargs (if npar npar (length args))))
        (apply f (cons (apply g (subseq args 0 nargs))
                       (nthcdr nargs args))))))


;; Pipeline: Make a function that composes a 
;; sequence of functions 
;; 
(defun pipeline (&rest funcs)
    #'(lambda (&rest args)
        (car (reduce
              #'(lambda (ar f) (list (apply f ar)))
              funcs
              :initial-value args))))


;; Checks whether all of a sequence of functions
;; (validators) return true
;;
(defun checker (&rest validators)
    #'(lambda (elem)
        (every (lambda (check) (funcall check elem)) validators)))


;; Dispatcher: Make a function from a list of functions 
;; that returns the result of the first of these that 
;; returns a non-nil value
;;
(defun dispatch (&rest funcs)
    #'(lambda (&rest args)
        (if (null funcs) nil
            ;; else
            (let ((result (apply (car funcs) args)))
                (if result result
                    ;; else
                    (apply (apply #'dispatch (cdr funcs)) args))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STRINGS AND I/O
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Split string at character
;; This function is not implemented here because it is part
;; of an exercise
;(defun string-split (c strg &optional (start 0)) ...


;; Parse string to float if possible, else return NIL
;;
(defun parse-float (strg)
  (if (stringp strg)
      (with-input-from-string (s strg)
        (let ((res (read s)))
          (if (eq (type-of res) 'single-float) res nil)))))


;; Parse string to int if possible, else return NIL
;;
(defun parse-int (strg)
  (ignore-errors (parse-integer strg)))


;; Read text file into string
;;
(defun file-to-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))


