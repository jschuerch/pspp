;; 
;; ERSTE SCHRITTE
;; (PSPP HS19)
;;

;; Versuche im Listener
;; ====================

;; das ist eine Liste
;; - genau genommen schon zwei Listen
;; - ziemlich wenig Syntax nötig...
;; - eine Liste von Symbolen
;; - das erste (quote) hat eine spezielle Bedeutung
(quote (was ist denn hier los ?))


;; das ' ist eine Abkürzung für quote
'(was ist denn hier los ?)


;; Listen kann man auch verschachteln
;; - beliebig tief
'(was ist (denn hier) los ?)


;; viele vordefinierte Funktionen manipulieren Listen
;; - listp ist selber eine Funktion, genauer: ein Prädikat
;; - Übergabe von Funktionen als Parameter
;; - steuert hier, was remove-if machen soll
(remove-if #'listp '(was ist (denn hier) los ?))


;; eine Liste muss kann verschiedene Datentypen enthalten
;; - zum Beispiel auch: Strings, Zahlen
'(die "Antwort" ist 42)


;; noch eine Liste
'(+ 1 2 3 4 5)

;; und wenn wir das Quote weglassen...
(+ 1 2 3 4 5)

;; Präfix-Notation
(sqrt 2)

;; Bruchzahlen
;; - an die Präfix-Notation muss man sich erst gewöhnen
(+ 1/4 1/4)


;; Übung
;; =====
;; was wird das Ergebnis sein?

(* 3 (+ 4 5))

(string-upcase "hi fans")

(defun was? (n) n)

(was? 17)

(identity 17)

(third '(defun was? (n) n))


;; Einfache Funktionen
;; ===================

(defun flaeche (laenge breite)
  (list 'rechteck
        'mit 'flaeche
        (* laenge breite)))


;; Aufgabe: breite &OPTIONAL

(defun flaeche2 (laenge &optional breite)
  (list (if breite 'rechteck 'quadrat)
        'mit 'flaeche
        (* laenge (or breite laenge))))


;; Fakultätsfunktion
;; =================
;; das "Hello World" der funktionalen Programmierung

(defun faku (n) 
  (if (< n 2) 1
      ;; else
      (* n (faku (- n 1)))))



;; REPL - Read Eval Print Loop
;; ===========================
;; und ihre Umsetzung in Common Lisp :)

(defun repl()
  (loop (print (eval (read)))))






