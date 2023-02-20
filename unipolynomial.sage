class Unipolynomial:
	#Initializing means parsing string expressions as an array. Expressions can only be made of characters: numbers, [indeterminate], "+", "^", and " ".
	def __init__(self, expression = "", indeterm = "", aux = []):		
		#Declaring some general stuff--------------------------------
		self.cetable = [0]
		self.indeterm = indeterm
		
		if expression == "":													#Special rule to construct by arrays
			self.cetable = aux
			if indeterm == "": self.indeterm = "x"
			return
		
		order = 0
		tent_num = ""
		is_exponent = false
		coef_sign = 1
		crt_coef = 0
		crt_exp = 0
		
		#Searching to find the highest order-------------------------
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
			#print("Bokstav: ", i, " Streng: ", tent_num, ", Eksponent?: ", is_exponent, ", Koeffesient: ", crt_coef, ", Eksponent: ", crt_exp) #DEBUGGING
			
		if len(tent_num) > 0: crt_exp = int(tent_num)
		if crt_exp > order: order = crt_exp		
		tent_num = ""
		is_exponent = false
		crt_exp = 0																#Finished finding the polynomials order. Then it will make a list.
		
		#Encoding the polynomial as a list, from lowest to highest order terms. That is for p=p_0 + ... + p_n x^n. We have p[n] = p_n.
		self.cetable = [0] * (order + 1)
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
				self.cetable[crt_exp] += crt_coef * coef_sign					#This is where the list gets updated. Then it will reset temporary variables and continue scan.
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
				self.cetable[crt_exp] += crt_coef * coef_sign					#This is where the list gets updated. Then it will reset temporary variables and continue scan.
				tent_num = ""
				is_exponent = false
				coef_sign = 1
				crt_exp = 0
				crt_coef = 0
		
		if tent_num != "":
			if is_exponent: crt_exp = int(tent_num)
			else: crt_coef = int(tent_num)
		self.cetable[crt_exp] += crt_coef * coef_sign
		
	def __str__(self):
		display_pol = ""
		order = len(self.cetable) - 1
		for i in range(order, -1, -1):
			if i < order and self.cetable[i] > 0: display_pol += " + "
			elif i < order and self.cetable[i] < 0: display_pol += " - "
			elif self.cetable[i] < 0: display_pol += "-"
			if self.cetable[i] != 0:
				if i == 0 or abs(self.cetable[i]) != 1: display_pol += str(abs(self.cetable[i]))
				if i > 0 and abs(self.cetable[i]) != 1: display_pol += "*"
				if i > 0: display_pol += self.indeterm
				if i > 1: display_pol += "^" + str(i)
		return(display_pol)
		
	def getOrder(self):
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
		
		
	def __mul__(self, other):
		prod = self.cetable														#SPM: Is this okay?
		left = self.cetable
		if isinstance(other, Unipolynomial): right = other.cetable
		else: right = [other]
		order = self.getOrder() + len(right)
		prod = [0] * order
		#print("p: ", left) #DEBUG
		#print("q: ", right) #DEBUG
		#print("Empty table: ", prod.cetable) #DEBUG
		for i in range(len(left)):
			for j in range(len(right)):
				#print("(i,j) is: ", (i,j)) #DEBUG
				#print("pi:", left[i], " qj:", right[j], "   p*q=", left[i] * right[j]) #DEBUG
				prod[i+j] += left[i] * right[j]
		return Unipolynomial(indeterm = self.indeterm, aux = prod)
		
#	def __truediv__(self, other):									
#		TODO
	
#	def __pow__(self, other):
#		TODO: will add a thing with fastexp