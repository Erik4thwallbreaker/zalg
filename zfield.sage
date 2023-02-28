class Zfield:
#Class for prime fields
	def __init__(self, characteristic):
		self.characteristic = characteristic

	def __str__(self):
		group_displaying = "{"
		for i in range(self.characteristic):
			group_displaying += f"{i}"
			if i < self.characteristic - 1:
				group_displaying += ", "
		group_displaying += "}"
		return group_displaying
		
	def list_elements(self):
		print(self)
	
class Zelement:
	def __init__(self, value, field):
		self.value = value
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
	
	def __mod__(self, other): #Helping operator so that can be used in later
		return self.value % other
		
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
		
	def __truediv__(self, other):													#NB: STUPID!!!!  Making stupid operator first. Can exchange for euclids algortihm later
		quot_value = 1
		for i in range(self.getCharacteristic()):
			if (other * i % self.getCharacteristic()) == self.value:
				quot_value = i
		return Zelement(quot_value, self.field)
	
	def __pow__(self, other):														#Should also be changed for fastexponentiation / Do it with regular modding
		pow_value = (self.value ** other) % self.getCharacteristic()
		return Zelement(pow_value, self.field)
		