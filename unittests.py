#Loading/importing
from unipolynomial import *
from zfield import *

F = Zfield(13)
a = Zelement(1, F)
b = Zelement(2, F)
c = Zelement(3, F)
mytable = [a,b,c]
mypol = Unipolynomial(aux=mytable)
print(mypol)
