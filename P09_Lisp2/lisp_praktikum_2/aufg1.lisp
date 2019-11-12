;; PSPP P09 schuejen
(format t "P09 - Aufgabe 1~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

;;
;; Mapping over a list
;;
(defun map-list (f seq)
  (cond ((null seq) nil)
        (t (cons (funcall f (car seq))
                 (map-list f (cdr seq))))))

;; or as an iterative implementation
;(defun map-list (f seq)
;    (loop for el in seq collect (funcall f el)))


;;
;; Sum of all list elements
;;
;(defun list-sum (seq)
;  (cond ((null seq) 0)
;        (t (+ (car seq) (list-sum (cdr seq))))))


;;
;; Product of all list elements
;;
;(defun list-mult (seq)
;  (cond ((null seq) 1)
;        (t (* (car seq) (list-mult (cdr seq))))))


;;
;; Abstraction
;;
(defun reduce-list (f init seq)
  (if (null seq) init
    (funcall f (car seq) (reduce-list f init (cdr seq)))))

(defun list-sum (seq)
  (reduce-list #'+ 0 seq))

(pr '("list-sum '(10 20 7)"))
(prRes (list-sum '(10 20 7)))

(defun list-mult (seq)
  (reduce-list #'* 1 seq))

(pr '("list-mult '(10 20 7)"))
(prRes (list-mult '(10 20 7)))


;;
;; Another frequently used list abstraction
;; Find a better name
;;
(defun filter (f seq)
  (cond ((null seq) nil)
        ((funcall f (car seq))
         (cons (car seq) (filter f (cdr seq))))
        (t (filter f (cdr seq)))))

(pr '("filter #'zerop '(2 5 0 6 0 0)"))
(prRes (filter #'zerop '(2 5 0 6 0 0)))

(defun isSmallerThan3 (n)
  (if (< n 3) T
    nil))
(pr '("filter #'isSmallerThan3 '(2 5 0 6 0 0)"))
(prRes (filter #'isSmallerThan3 '(2 5 0 6 0 0)))











;
