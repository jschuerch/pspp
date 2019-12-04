from strcodes import strcodes

def strsum(str):
    return sum(strcodes(str))

print("strcodes('Hallo')")
print(strcodes("Hallo"))

print()
print("list map lambda")
print(list(map(lambda c: ord(c), "Hallo")))

print()
print("list map ohni lambda")
print(list(map(ord, "Hallo")))

print()
print("strsum('Hallo')")
print(strsum("Hallo"))


print()
print()
print("-- Dictionaries -------------------------------------------")

def printdict(dict):
    for key in sorted(dict):
        print("%s\t%s" % (key, dict.get(key)))

print()
print("printdict")
printdict({"beta": 22, "alfa": 11, "gamma": 33})

def addDict(dict1, dict2):
    dict = dict1.copy()
    for k, v in dict2.items():
        if not k in dict.keys():
            dict[k] = v
    return dict

print()
print("addDict")
print(addDict({1:111, 2:222}, {2:999, 3:333}))


print()
print("-- Methodenverzeichnis -------------------------------------------")
# gibt alle verfügbaren attribute und funktionen aus, welche auf array/liste angewendet werden können
print(dir([]))
# gibt alle verfügbaren attribute und  funktionen aus, welche auf dictionary angewendet werden können
print(dir({}))
# gibt eine values-funktion aus (noch nicht ausgeführt
print({}.values)
# gibt dokumentation der methode aus
print({}.values.__doc__)


print()
print("-- Mengen -------------------------------------------")

def union(lst1, lst2):
    return list(set(lst1 + lst2))

print()
print("union")
print(union([1, 2, 3], [3, 4]))

def diff(lst1, lst2):
    lst = lst1.copy()
    for l in lst2:
        if l in lst:
            lst.remove(l)
    return lst

print()
print("diff")
print(diff([1, 2, 3], [3, 4]))


print()
print("-- Flache Liste -------------------------------------------")
print()

def flatten(lst):
    if type(lst) != list and type(lst) != tuple:
        return [lst]
    flat = []
    for l in lst:
        #flat = union(flat, flatten(l))
        flat += flatten(l)
    return flat

print("flatten")
print(flatten([[[1, 2], 3], [[4]], (5, 6), ([7])]))
