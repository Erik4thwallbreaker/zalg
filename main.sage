#Loading/importing
load ("unipolynomial.sage")
load("zfield.sage")

# Doing some things
K = Zfield(13)
a = Zelement(2, K)
b = a + a
p = Unipolynomial(aux = [2, 0, 1])
q = Unipolynomial("x-1", "x")
print("p: ", p)
print("q: ", q)
r = p * q
print("r: ", r)