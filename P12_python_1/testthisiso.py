##
## Beispiel zum Testen
## ACHTUNG: quick&dirty, enthaelt noch keinerlei Fehlerbehandlung
##

import urllib.parse
import http.client
import re

def doloadiso(url):
    o = urllib.parse.urlparse(url)
    conn = http.client.HTTPConnection(o.netloc)
    conn.request("GET", o.path)
    resp = conn.getresponse()
    data = resp.read().decode(encoding="iso8859-1")
    withouttags = re.sub(r"<(.|\s)*?>", "", data)
    return re.sub(r"\s+", " ", withouttags).split()
