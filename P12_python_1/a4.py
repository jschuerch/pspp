"""
Dieses Script gibt die Fibonacci folge kleiner 200 aus.
"""

a, b = 0, 1
while b < 200:
    #gib b aus mit leerzeichen am schluss, damit zahlen nicht aneinander kleben (ohne zeilenumbruch)
    print(b, end=' ')

    # swap:   b = a   und   b = a+b   --> ohne temp variable
    a, b = b, a+b