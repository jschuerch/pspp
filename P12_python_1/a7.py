import testthis

"""
doload: 
liest den Inhalt einer Webseite und entfernt die HTML-Attribute.
Der Inhalt wird als Liste zurückgegeben.
"""

print(testthis.doload("http://dublin.zhaw.ch/~bkrt/hallo.html"))
# ['Hello', 'Hallo', 'Ich', 'bin', 'eine', 'Webseite']

print(testthis.doload("http://lite.cnn.io/en"))
