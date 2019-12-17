bands = [{'name': 'sunset rubdown', 'country': 'UK', 'active': False},
{'name': 'women', 'country': 'Germany', 'active': False},
{'name': 'a silver mt. zion', 'country': 'Spain', 'active': True}]

def format_bands(bands):
    for band in bands:
        band['country'] = 'Canada'
        band['name'] = band['name'].replace('.', '')
        band['name'] = band['name'].title()

#format_bands(bands)
#print(bands)
"""[{'name': 'Sunset Rubdown', 'active': False, 'country': 'Canada'},
{'name': 'Women', 'active': False, 'country': 'Canada' },
{'name': 'A Silver Mt Zion', 'active': True, 'country': 'Canada'}]"""
### Wozu dient die Funktion format_bands?
# Funktion ändert für jedes Objekt das Land auf Canada
# entfernt den Punkt von den Namen
# macht jeder Anfangsbuchstabe im Namen gross

# Man kann nicht wirklich von einer definierten Zuständigkeit sprechen,
# da die Funktion mehrere Aufgaben gleichzeitig erledigt.


# Aufgabe 1 ############################################################################

def assoc(_d, key, value):
    from copy import deepcopy
    d = deepcopy(_d)
    d[key] = value
    return d

def pipeline_each(data, fns):
    import functools
    return functools.reduce(lambda a, fn: list(map(fn, a)),
                            fns, data)

def set_canada_as_country(band):
    return assoc(band, "country", "Canada")

def strip_punctuation_from_name(band):
    return assoc(band, "name", band["name"].replace(".", ""))

def capitalize_names(band):
    return assoc(band, "name", band["name"].title())

newbands = pipeline_each(bands, [set_canada_as_country,
    strip_punctuation_from_name,
    capitalize_names])

print(bands)
print(newbands)

# Aufgabe 2 ############################################################################
import functools
def func(a, b):
    return a+b
print("no init: " + functools.reduce(func, ["hello world", "help me", "asdf asdf", "blub"]))
print("   init: " + functools.reduce(func, ["hello world", "help me", "asdf asdf", "blub"], "first"))

# reduce(function, sequence[, initial]) -> value
# 1. Initially, the function is called with the first two items from the
#    sequence and the result is returned.
# 2. The function is then called again with the result obtained in step 1
#     and the next value in the sequence. This process keeps repeating until
#     there are items in the sequence.
# When the initial value is provided, the function is called with the initial
# value and the first item from the sequence.

def func2(a):
    return a*2
print(list(map(func2, ["hello world", "help me", "asdf asdf", "blub"])))
# map(fun, iter)
# fun : It is a function to which map passes each element of given iterable.
# iter : It is a iterable which is to be mapped.
# Returns a list of the results after applying the given function
# to each item of a given iterable (list, tuple etc.)

# Aufgabe 3 ############################################################################

def call(fn, key):
    def apply_fn(record):
        return assoc(record, key, fn(record.get(key)))
    return apply_fn

set_canada_as_country = call(lambda x: 'Canada', 'country')
strip_punctuation_from_name = call(lambda x: x.replace(".",""), 'name')
capitalize_names = call(lambda x: x.title(), 'name')


newbands2 = pipeline_each(bands, [set_canada_as_country,
    strip_punctuation_from_name,
    capitalize_names])

print(bands)
print(newbands2)

# Aufgabe 4 (1a) ############################################################################
"""
def select(keys):
    import functools
    def apply_fn(record):
        record = functools.reduce(lambda a, b: assoc(a,b,record[b]), keys, {})
    return apply_fn

newbands3 = pipeline_each(bands, [set_canada_as_country,
    strip_punctuation_from_name,
    capitalize_names,
    select(['name', 'country']) ])

print(bands)
print(newbands3)
"""


