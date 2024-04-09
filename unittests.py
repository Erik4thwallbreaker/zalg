#Loading/importing
from unipolynomial import *
from zfield import *

F = Zfield(13)
a = Zelement(5, F)
b = Zelement(10, F)
c = Zelement(15, F)
mytable = [a,b,c]
mypol = Unipolynomial(aux=mytable)
print(mypol * 1)
