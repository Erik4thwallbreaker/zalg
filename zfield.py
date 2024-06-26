#Class for prime fields
class Zfield:
	def __init__(self, characteristic):
		self.characteristic = characteristic

	def canon(self, number):
		return number % self.characteristic

	def __iter__(self):
		self.counter = 0
		return self

	def __next__(self):
		if self.counter >= self.characteristic:
			raise StopIteration
		t = self.counter
		self.counter += 1
		return t

	def __str__(self):
		group_displaying = "{"
		for i in range(self.characteristic):
			group_displaying += str(i)
			if i < self.characteristic - 1:
				group_displaying += ", "
		group_displaying += "}"
		return group_displaying
		
	def list_elements(self):
		print(self)

#Class for the elements of such fields
class Zelement:
	def __init__(self, value, field):
		self.value = field.canon(value)
		self.field = field

	def getCharacteristic(self):
			return self.field.characteristic
	
	def __str__(self):
		return str(self.value)
	
	def __eq__(self, other):
		if isinstance(other, Zelement):
			return self.field == other.field and self.value == other.value
		else:
			return other % self.getCharacteristic() == self.value

	def __gt__(self, other):
		if isinstance(other, Zelement):
			return self.field != other.field or self.value != other.value
		else:
			return self.value > other
		
	def __ge__(self, other):
		if isinstance(other, Zelement):
			return True
		else:
			return self.value >= other 

	def __lt__(self, other):
		if isinstance(other, Zelement):
			return self.field != other.field or self.value != other.value
		else:
			return self.value < other
		
	def __le__(self, other):
		if isinstance(other, Zelement):
			return True
		else:
			return self.value <= other 

	def __ne__(self, other):
		if isinstance(other, Zelement):
			return self.field != other.field or self.value != other.value
		else:
			return self.value != other % self.getCharacteristic()

	def __mod__(self, other): #Helping operator so that can be used in later
		return self.value % other

	def __abs__(self):
		return self
		
	def __add__(self, other):
		sum_value = (other + self.value) % self.getCharacteristic()
		return Zelement(sum_value, self.field)
	
	def __radd__(self, other):
		return self + other
		
	def __sub__(self, other):
		diff_value = (other - self.value) % self.getCharacteristic()
		return Zelement(diff_value, self.field)
		
	def __rsub__(self, other):
		diff_value = (other - self.value) % self.getCharacteristic()
		return Zelement(diff_value, self.field)
		
	def __mul__(self, other):
		prod_value = (other * self.value) % self.getCharacteristic()
		return Zelement(prod_value, self.field)
		
	def __rmul__(self, other):
		return self * other
		
	def __truediv__(self, other):													#Should implement euclids algortihm for this, later.
		quot_value = 1
		for i in range(self.getCharacteristic()):
			if (other * i % self.getCharacteristic()) == self.value:
				quot_value = i
		return Zelement(quot_value, self.field)
	
	def __pow__(self, other):
		result = 1
		nsquared = self
		for b in reversed(format(other, 'b')):
			if int(b):
				result = result * nsquared
			nsquared = nsquared * nsquared
		return result
