def adder(a, b):
    return a + b;

version = 1.0
if __name__ == '__main__':
    print('Module testcode started separately...')

# Tests
print(adder(3, 34))
assert(adder(3, 34) == 37)
print(adder("Hello", "World"))
print(adder([1, 3, 7], [4, 8]))
print(adder((1, 3, 6), (4, 9)))