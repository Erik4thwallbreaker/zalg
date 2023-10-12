#Loading/importing
from unipolynomial import *
from zfield import *

# Doing some things
assert(str(Unipolynomial("2x^3 + x + 440", "x")) == "2*x^3 + x + 440")
a = Unipolynomial("x + 1", "x")
assert(a*a == Unipolynomial("x^2 + 2x + 1", "x"))
assert(a**1 == a)
assert(a**2 == a*a)
assert(a**3 == a*a*a)

