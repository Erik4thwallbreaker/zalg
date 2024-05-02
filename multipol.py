#Free commutative monoid: A class with just enough structure to allow free polynomial ring mulitlpication.
class Fcm:																
	@staticmethod																					#Abelian monoid operation. Adds indexes together without creating duplicates, (potentially zeroes)
	def abela(lefthand, righthand):																	#Returns shallow copy of first argument. Mathematically correct.
		prod = dict(lefthand)
		for key,value in righthand.items():
			if key in prod:
				prod[key] += righthand[key]
			else:
				prod[key] = righthand[key]
		return prod


	def __init__( self, indeterms = (), indices = () ):
		pro_dict = {key: value for key, value in zip(indeterms, indices) if value != 0}
		self.indeterms = tuple(pro_dict.keys())														#Can be strings for formal multiplication or other ring objects.
		self.indices = tuple(pro_dict.values())														#Int - the order with respect to each indeterminate.

	def __iter__(self):																				
		return iter(zip(self.indeterms, self.indices))

	def __eq__(self, other):
		return dict(self) == dict(other)

	def __ne__(self, other):
		return not(self == other)

	def __hash__(self):
		return hash(frozenset(zip(self.indices, self.indeterms)))

	def __mul__( self, other):																		#Assumes the indices refer to the same indeterminates and therefore have equal length.
		prod_dict = Fcm.abela(dict(self), dict(other))
		return Fcm( indeterms = tuple(prod_dict.keys()), indices = tuple(prod_dict.values()) )		#TODO Make shoter and prettier

	def __str__(self):																				#Has its own structure for the string expression of a single product/power.
		all_factors = ['^'.join(i) for i in zip(map(str, self.indeterms), map(str, self.indices)) ]	#TODO Make nicer. With better list comprehension.
		return ' '.join(all_factors)


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
		for key, value in righthand.items():														#TODO Fix
			for key, value in righthand.items():
				if key in lefthand:
					lefthand[key] += righthand[key]
				else:
					lefthand[key] = righthand[key]
		return Multipolynomial(lefthand)

