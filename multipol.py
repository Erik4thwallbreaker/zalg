#Free commutative monoid: A class with just enough structure to allow free polynomial ring mulitlpication.
class Fcm:																
	def __init__( self, indices = () ):
		self.indices = indices																		#Tuple keeping track of the order with respect to each indeterminate.

	def __iter__(self):
		self.counter = 0
		return self

	def __next__(self):
		if self.counter >= len(self.indices):
			raise StopIteration
		self.counter += 1
		return self.indices[self.counter - 1]

	def __mul__( self, other):																		#Assumes the indices refer to the same indeterminates and therefore have equal length.
		return tuple(( sum(i) for i in zip(self.indices, other.indices) ))


#----------------------------------------------------------------------------------------------------
#A class for computations in a polynomial algebra over any finite set of indeterminates.
#Allows some freedom in choosing from which rings to draw both coeffecients and indeterminates.
class Multipolynomial:
	def __init__(self, terms={}, indeterms = ()):
		self.terms = terms																			#Dictionary. The keys note indices (tuple-like). The values note coeffecients.
		self.indeterms = indeterms																	#Keeps track of the indeterminate. Both for naming and for ring membership.

	def __str__(self):
		all_terms = []
		for key, value in self.terms.items():
			single_term = str(value) + ' '
			all_factors = [ '^'.join(i) for i in zip(self.indeterms, map(str, key))  ]
			single_term += ''.join(all_factors)
			all_terms.append(single_term)
		return ' + '.join(all_terms)






mydict = {Fcm((2,0)):1, Fcm((1,1)):2, Fcm((0,2)):1}
mychars = ('x','y')
mypol = Multipolynomial(mydict, mychars)
print(mypol)
