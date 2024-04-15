#Free commutative monoid: A class with just enough structure to allow free polynomial ring mulitlpication.
class Fcm:																
	def __init__( self, indices = (), indeterms = () ):
		self.indices = indices																		#The order with respect to each indeterminate.
		self.indeterms = indeterms																	#Can be strings, or more esoteric ring objects. MUST BE EQUAL LENGTH.

	def __iter__(self):
		self.counter = 0
		return self

	def __next__(self):
		if self.counter >= len(self.indices):
			raise StopIteration
		self.counter += 1
		return self.indices[self.counter - 1]

	def __eq__(self, other):
		return self.indices == other.indices

	def __ne__(self, other):
		return not(self == other)

	def __hash__(self):
		return hash(self.indices)

	def __mul__( self, other):																		#Assumes the indices refer to the same indeterminates and therefore have equal length.
		return tuple(( sum(i) for i in zip(self.indices, other.indices) ))							#TODO Is outdated. Need fixing to work with different sequences of indetermiantes.

	def __str__(self):																				#Has its own structure for the string expression of a single product/power.
		all_factors = ['^'.join(i) for i in zip(map(str, self.indeterms), map(str, self.indices)) ]	#TODO Make nicer. With better list comprehension.
		return ''.join(all_factors)


#----------------------------------------------------------------------------------------------------
#A class for computations in a polynomial algebra over any finite set of indeterminates.
#Allows some freedom in choosing from which rings to draw both coeffecients and indeterminates.
class Multipolynomial:
	def __init__(self, terms={}):
		self.terms = terms																			#Dictionary. The keys note indices (tuple-like). The values note coeffecients.

	def __str__(self):
		all_terms = [ str(value) + ' ' + str(key) for key, value in self.terms.items() ]
		return ' + '.join(all_terms)

	def __add__(self, other):																		#Addition by other polynomials or numbers?
		if isinstance(other, Multipolynomial):
			lefthand = dict(self.terms)
			righthand = dict(other.terms)
		else:																						#Adds numeric types as constant polynomials. TODO Adds string types through the string interpreter.
			lefthand = dict(self.terms)
			righthand = {Fcm(): other}															
		for key, value in righthand.items():
			for key, value in righthand.items():
				if key in lefthand:
					lefthand[key] += righthand[key]
				else:
					lefthand[key] = righthand[key]
		return Multipolynomial(lefthand)




myc = ('x','y')
coefs1 = {Fcm((2,0), myc):1, Fcm((1,1), myc):2, Fcm((0,2), myc):1}
coefs2 = {Fcm((2,0), myc):4}
pol1 = Multipolynomial(coefs1)
pol2 = Multipolynomial(coefs2)
pol3 = pol1 + pol2
print(pol1)
print(pol2)
print(pol3)
