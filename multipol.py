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

	def __init__( self, indeterms, indices = (0,)):
		if not isinstance(indeterms, dict):
			as_dict = {key: value for key, value in zip(indeterms, indices) if value != 0}
		else:
			as_dict = indeterms
		self.indeterms = tuple(as_dict.keys())														#can be strings for formal multiplication or other ring objects.
		self.indices = tuple(as_dict.values())														#Int - the order with respect to each indeterminate.

	def __iter__(self):																				
		return iter(zip(self.indeterms, self.indices))

	def __eq__(self, other):
		return dict(self) == dict(other)

	def __ne__(self, other):
		return not(self == other)

	def __hash__(self):
		return hash(frozenset(zip(self.indices, self.indeterms)))

	def __mul__( self, other):																		#Assumes the indices refer to the same indeterminates and therefore have equal length.
		return Fcm(Fcm.abela(dict(self), dict(other)))

	def __str__(self):																				#Has its own structure for the string expression of a single product/power.
		all_factors = [i + '^' + j for i,j in zip(map(str, self.indeterms), map(str, self.indices)) ]
		return ' '.join(all_factors)


#----------------------------------------------------------------------------------------------------
#A class for computations in a polynomial algebra over any finite set of indeterminates.
#Allows some freedom in choosing from which rings to draw both coeffecients and indeterminates.
class Multipolynomial:
	def __init__(self, expression = '', as_dict=None, indeterms=None, coeffs=None):										
		if not as_dict is None:
			self.terms = as_dict
		elif not indeterms is None or not coeffs is None:
			if not indeterms is None:
				indeterms_list = list(indeterms)
			else:
				indeterms_list = [ Fcm(dict()) ]
			if not coeffs is None:
				coeffs_list = list(coeffs)
			else:
				coeffs_list = [1]
			self.terms = dict(zip(indeterms_list,coeffs_list))
		else:																						#TODO Add string comprehension
			self.terms = {0:0}

	def __str__(self):
		all_terms = [ str(value) + ' ' + str(key) for key, value in self.terms.items() ]
		return ' + '.join(all_terms)

	def __add__(self, other):																		#Addition by other polynomials or numbers?
		return Multipolynomial(as_dict = Fcm.abela(self.terms, other.terms))
