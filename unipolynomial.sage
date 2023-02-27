class Unipolynomial:

	#Declaring static methods for interpreting strings
	@staticmethod
	def findOrder(expression, indeterm):							#Searching to find the highest exponent in the expression (string).
		order = 0
		tent_num = ""
		is_exponent = false
		crt_exp = 0
		for i in expression:
			if i in [" ", "^", "*"]:
				pass
			elif i == indeterm:
				is_exponent = true
				crt_exp = 1
			elif is_exponent and not i in ["+", "-"]:
				tent_num += i
			elif i in ["+", "-"]:
				if is_exponent:
					if tent_num != "": crt_exp = int(tent_num)
					if crt_exp > order: order = crt_exp
				tent_num = ""
				is_exponent = false
			
		if tent_num != "": crt_exp = int(tent_num)
		if crt_exp > order: order = crt_exp
		return order
	
	@staticmethod
	def parseExpression(expression, indeterm):						#Searching to interpret the expression string as a list
		order = Unipolynomial.findOrder(expression, indeterm)
		tent_num = ""
		is_exponent = false
		coef_sign = 1
		crt_coef = 0
		crt_exp = 0
		cetable = [0] * (order + 1)
		for i in expression:
			if i in [" ", "^" ,"*"]:
				pass
			elif not i in [indeterm, "+", "-"]:
				tent_num += i
			elif i == indeterm:
				is_exponent = true
				crt_exp = 1														#In the case of "...a x +..."
				if tent_num != "": crt_coef = int(tent_num)						#The regular case
				if crt_coef == 0: crt_coef = 1									#In the case of "...+ x^n +..."
				tent_num = ""
			elif i == "-":
				if not is_exponent:
					if tent_num != "": crt_coef = int(tent_num)
				else:
					if tent_num != "": crt_exp = int(tent_num)
				cetable[crt_exp] += crt_coef * coef_sign					#This is where the list gets updated. Then it will reset temporary variables and continue scan.
				tent_num = ""
				is_exponent = false
				coef_sign = -1
				crt_exp = 0
				crt_coef = 0
			elif i == "+":
				if not is_exponent:
					if tent_num != "": crt_coef = int(tent_num)
				else:
					if tent_num != "": crt_exp = int(tent_num)
				cetable[crt_exp] += crt_coef * coef_sign					#This is where the list gets updated. Then it will reset temporary variables and continue scan.
				tent_num = ""
				is_exponent = false
				coef_sign = 1
				crt_exp = 0
				crt_coef = 0
		
		if tent_num != "":
			if is_exponent: crt_exp = int(tent_num)
			else: crt_coef = int(tent_num)
		cetable[crt_exp] += crt_coef * coef_sign
		return cetable
	
	
	def __init__(self, expression = "", indeterm = "x", aux = []):	#Expressions can only be made of characters: numbers, [indeterminate], "+", "^", and " ".
	
		if expression == "":										#Special rule to construct by arrays											
			self.cetable = aux
		else:														#Constructing by expression string
			self.cetable = Unipolynomial.parseExpression(expression, indeterm)
		if indeterm == "":
			self.indeterm = "x"
		else:
			self.indeterm = indeterm
	
	@staticmethod
	def expressPolynomial(coeffecients, indeterm = "x"):	#Helping method, to write polynomial as a string from coeffecient table
		if all([i == 0 for i in coeffecients]):
			return "0"
		else:
			display_pol = ""
			order = len(coeffecients) - 1
			for i in range(order, -1, -1):
				if i < order and coeffecients[i] > 0: display_pol += " + "
				elif i < order and coeffecients[i] < 0: display_pol += " - "
				elif coeffecients[i] < 0: display_pol += "-"
				if coeffecients[i] != 0:
					if i == 0 or abs(coeffecients[i]) != 1: display_pol += str(abs(coeffecients[i]))
					if i > 0 and abs(coeffecients[i]) != 1: display_pol += "*"
					if i > 0: display_pol += indeterm
					if i > 1: display_pol += "^" + str(i)
			return display_pol
	
	def __str__(self):
		return Unipolynomial.expressPolynomial(self.cetable, self.indeterm)
		
	def getOrder(self):												#Get the order of a polynomial (class object).
		return len(self.cetable) - 1
	
	def __add__(self, other):
		left = self.cetable
		if isinstance(other, Unipolynomial): right = other.cetable
		else: right = [other]
		overlap_length = min(len(left), len(right))
		sum = [left[i] + right[i] for i in range(0, overlap_length)]
		sum += [left[i] for i in range(overlap_length, len(left))]
		sum += [right[i] for i in range(overlap_length, len(right))]
		return Unipolynomial(indeterm = self.indeterm, aux = sum)
		
	def __radd__(self, other):
		return self + other	
		
	def __mul__(self, other):
		left = self.cetable
		if isinstance(other, Unipolynomial): right = other.cetable
		else: right = [other]
		order = self.getOrder() + len(right)
		prod = [0] * order
		for i in range(len(left)):
			for j in range(len(right)):
				prod[i+j] += left[i] * right[j]
		return Unipolynomial(indeterm = self.indeterm, aux = prod)
		
	def __rmul__(self, other):
		return self * other
	
	@staticmethod
	def doubleValDiv(left, right):				#Helping function that picks out both the floordiv, and the remainder. Assuming both inputs to be non-empty lists.
		r = len(right) - 1													#Order of the right polynomial. Handier to write like this.
		order = len(left) - r - 1										#Actual order of resulting polynomial.
		quot = [0] * (order + 1)
		for i in range(order, -1, -1):
			quot[i] = left[i+r] / right[r]
			subtrahend = [right[j] * quot[i] for j in range(r)]				#Don't need to subtract from the highest term. It will not be used again.			
			for j in range(r): left[i+j] -= subtrahend[j]
		remainder = [left[i] for i in range(r)]
		return [quot, remainder]
		
	def __truediv__(self, other):		
		left = self.cetable
		if isinstance(other, Unipolynomial): right = other.cetable
		else: right = [other]
		quotient = Unipolynomial.doubleValDiv(left, right)
		remainder = quotient[1]
		if not all([i == 0 for i in remainder]):
			print("Division doesn't terminate. Remainder:", Unipolynomial.expressPolynomial(remainder, self.indeterm))
		return Unipolynomial(indeterm = self.indeterm, aux = quotient[0])
	
	def __floordiv__(self, other):											
		left = self.cetable
		if isinstance(other, Unipolynomial): right = other.cetable
		else: right = [other]
		quotient = Unipolynomial.doubleValDiv(left, right)
		return Unipolynomial(indeterm = self.indeterm, aux = quotient[0])
	
#	def __pow__(self, other):
#		TODO: will add a thing with fastexp