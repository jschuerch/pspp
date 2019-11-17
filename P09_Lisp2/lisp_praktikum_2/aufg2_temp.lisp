;; PSPP P09 schuejen
(format t "P09 - Aufgabe 2~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

;;
;; Testing the range function
;;


;; Create range of integers
;; This is not a working range function
;;
(defun range-rek (a b c)
  (cond ((>= a b) nil)
    (t (cons a (range-rek (+ a c) b)))))

(defun range (&rest args)
  (if (< (list-length args) 1) nil
    ((set 'a (if (= (list-length args) 1) 0 (car args)))
    (set 'b (or (cadr args) (car args)))
    (set 'c (or (caddr args) 1))
    (range-rek a b c))))

(defun range-simple (a b)
  (cond ((>= a b) nil)
    (t
      (cons a (range-simple (+ a 1) b))
      )))

(pr '("range-simple 0 5"))
(prRes (range-simple 0 5))

(pr '("range 8"))
(prRes (range 8))
(pr '("range 5 10"))
(prRes (range 5 10))
(pr '("range 5 20 3"))
(prRes (range 5 20 3))
(pr '("range 10 2 -1"))
(prRes (range 10 2 -1))
(pr '("range 5 5"))
(prRes (range 5 5))
(pr '("range 5 2"))
(prRes (range 5 2))
(pr '("range -5 2"))
(prRes (range -5 2))
(pr '("range -5"))
(prRes (range -5))




;; Minimalist test tool
;; (flet, handler-case are not part of the PSPP topics)
;;
(defun run-tests (tests)
  (flet ((run-one (test)
           (handler-case (apply (first test) (second test))
             (error (c) (cadr (list c "throws error"))))))
    (cond ((null tests) "all ok")
          (t (let ((test (car tests)))
               (if (equal (run-one test) (third test))
                   (run-tests (cdr tests))
                   (format t "~S should be: ~S but is: ~S~%"
                           (cons (first test) (second test))
                           (third test)
                           (run-one test))))))))


;; Some tests for range function
;;
(run-tests '(
  (range (0 5)
      (0 1 2 3 4))
  (range (3 5)
      (3 4))
  (range (0 0)
      nil)
  (range (0 10 2)
      (0 2 4 6 8))
  (range (10 30 5)
      (10 15 20 25))
  (range (5)
      (0 1 2 3 4))
  (range (5 10 -1)
      nil)
  (range (10 5 -1)
      (10 9 8 7 6))
))
