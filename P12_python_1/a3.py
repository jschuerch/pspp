#string kontaktenationen
"spam" + "eggs"
s = "ham"
"eggs " + s

#wiederholt string 5 mal
s * 5

#2. buchstabe + 1. und 2. Buchstabe
s[1]+s[:-1]

#format string
"green %s and %s" % ("eggs", s)

# 2. element von tupel
('x', 'y')[1]

# 2 listen zusammenhängen
z = [1, 2, 3] + [4, 5, 6]

# verschiedene slices der liste
z, z[:], z[:0], z[-2], z[-2:]

# reverse (destruktiv)
z.reverse(); z

#dictionaries, gib value mit key b zurück
{'a':1, 'b':2}['b']

#einträge hinzufügen mit key 'w' und (1,2,3)
d = {'x':1, 'y':2, 'z':3}
d['w'] = 0
d[(1,2,3)] = 4

#gib keys au
d.keys()

# liste der keys und liste der values in einem tupel
list(d.keys()), list(d.values())