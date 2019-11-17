;; PSPP P09 schuejen
(format t "P09 - Aufgabe 4-5~%")

; Formatted print
(defun pr (val) (format t "~%~s~%" val))
(defun prRes (val) (format t "--> ~s~%" val))

;; file-to-string
;; Read text file into string
;;
(defun file-to-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))

;; alternative implementation in case the Common Lisp used does not
;; support the read-sequence function
;;
(defun file-to-string (path)
  (with-open-file (stream path)
    (apply #'concatenate
           (cons 'string
                 (loop
                   for line = (read-line stream nil 'eof)
                   until (eq line 'eof)
                   collect (format nil "~A~%" line))))))

;(prRes (file-to-string "products.csv"))

;; string-split
;; Split string at character
;;
(defun string-split (c strg &optional (start 0))
  (let ((end (position c strg :start start)))
    (cond (end (cons (subseq strg start end)
                    (string-split c (subseq strg (1+ end)) 0))) ;; MISSING LINE ...
          (t (list (subseq strg start))))))

(pr '("string-split #\Space 'eins zwei drei'"))
(prRes (string-split #\Space "eins zwei drei"))

(pr '("string-split #\, 'eins,zwei,drei'"))
(prRes (string-split #\, "eins,zwei,drei"))


;; simple-csv
(defun simple-csv (csv)
  (mapcar (lambda (x) (string-split #\, x)) (string-split #\Newline csv)))

(pr '("simple-csv (file-to-string 'products.csv')"))
(prRes (simple-csv (file-to-string "products.csv")))


;; parse-float
;; Parse string to float if possible, else return NIL
;;
(defun parse-float (strg)
  (with-input-from-string (s strg)
    (let ((res (read s)))
      (if (eq (type-of res) 'single-float) res nil))))


;; zip-to-alist
;; Merge two lists to an alist
;; Fügt die Elemente aus der ersten Listen mit den Elementen aus der zweiten Liste
;; als (key . value)-Paar zusammen
(defun zip-to-alist (lst1 lst2)
  (cond ((or (null lst1) (null lst2)) nil)
        (t (cons (cons (car lst1) (car lst2))
                 (zip-to-alist (cdr lst1) (cdr lst2))))))

(pr '("zip-to-alist '(a b c) '(4 5 6)"))
(prRes (zip-to-alist '(a b c) '(4 5 6)))


;(pr '("test-code"))
;(prRes (defvar *people* '(("name" . "Hans") ("age" . "29") ("hair" . "braun"))))
;(prRes (assoc "age" *people* :test #'string=))

;; make-alis
(defun make-alist (csvlist)
  (mapcar (lambda (x) (zip-to-alist (car csvlist) x)) (cdr csvlist)))

(pr (defvar *products-csv* (simple-csv (file-to-string "products.csv"))))

(pr '("make-alist *products-csv*"))
(prRes (make-alist *products-csv*))
