class_name BigNumber

var value : float
var expoent : int

func _init(value: float = 0, expoent : int = 1):
	self.value = value
	self.expoent = expoent
	
static func align(a : BigNumber, b: BigNumber):
	if a.exp > b.exp:
		var expoentDifference: int = a.exp - b.exp;
		if expoentDifference > 0:
			b.value = b.value / pow(10, expoentDifference) if (expoentDifference <= BigNumberConstants.MAX_EXP_DIFFERENCE) else 0
			b.exp = a.exp
	else:
		var expoentDifference: int = b.exp - a.exp;
		if expoentDifference > 0:
			a.value = a.value / pow(10, expoentDifference) if (expoentDifference <= BigNumberConstants.MAX_EXP_DIFFERENCE) else 0
			a.exp = b.exp
	
static func multiply(a: BigNumber, b) -> BigNumber:
	var result: BigNumber
	var copyA = BigNumber.new(a.value, a.exp)
	var copyB = BigNumber.new(b.value, b.exp)
	if typeof(b) == typeof(BigNumber):
		align(copyA, copyB)
		result = BigNumber.new(copyA.value * copyB.value, copyA.exp)
		result.normalize()
	else:
		result = BigNumber.new(copyA.value * b, copyA.exp)
		result.normalize()
	return result
	
static func divide(a: BigNumber, b) -> BigNumber:
	var result: BigNumber
	var copyA = BigNumber.new(a.value, a.exp)
	var copyB = BigNumber.new(b.value, b.exp)
	if typeof(b) == typeof(BigNumber):
		align(copyA, copyB)
		result = BigNumber.new(copyA.value / copyB.value, copyA.exp)
		result.normalize()
	else:
		result = BigNumber.new(copyA.value / b, copyA.exp)
		result.normalize()
	return result

static func sum(a: BigNumber, b) -> BigNumber:
	var copyA = BigNumber.new(a.value, a.exp)
	var copyB = BigNumber.new(b.value, b.exp)
	align(copyA, copyB)
	var result: BigNumber = BigNumber.new(copyA.value + copyB.value, copyA.exp)
	result.normalize()
	return result

static func subtract(a: BigNumber, b) -> BigNumber:
	var copyA = BigNumber.new(a.value, a.exp)
	var copyB = BigNumber.new(b.value, b.exp)
	align(copyA, copyB)
	var result: BigNumber = BigNumber.new(copyA.value - copyB.value, copyA.exp)
	result.normalize()
	return result

static func power(a: BigNumber, b):
	a.value = pow(a.value, b);
	a.exp *= b;
	return a;
	
static func equal(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA,  copyB)
		return copyA.value == copyB.value
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA,  copyB)
	return copyA.value == copyB.value
		
static func different(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA, copyB)
		return copyA.value != copyB.value
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA, copyB)
	return copyA.value != copyB.value
	
static func greater_than(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA, copyB)
		return copyA.value > copyB.value
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA, copyB)
	return copyA.value > copyB.value
	
static func greater_or_equal_than(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA, copyB)
		return copyA.value >= copyB.value
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA, copyB)
	return copyA.value >= copyB.value
		
static func less_than(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA, copyB)
		return copyA.value < copyB.value
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA, copyB)
	return copyA.value < copyB.value
		
static func less_or_equal_than(a : BigNumber, b):
	var copyA
	var copyB
	if typeof(b) == typeof(BigNumber):
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b.value, b.exp)
		align(copyA, copyB)
	else:
		copyA = BigNumber.new(a.value, a.exp)
		copyB = BigNumber.new(b, 1)
		align(copyA, copyB)
	return copyA.value <= copyB.value

func get_unit(magnitude: int) -> String:
	var unit: String
	var letters_in_the_alphabet = 26
	var a_position = 65
	if magnitude < BigNumberConstants.UNITS.size():
		unit = BigNumberConstants.UNITS[magnitude]
	else:
		var magnitude_difference = magnitude - BigNumberConstants.UNITS.size()
		#defining the letters of the unit symbol
		var second_letter = magnitude_difference % letters_in_the_alphabet
		var first_letter = magnitude_difference / letters_in_the_alphabet
		if first_letter > 26:
			unit = " a lot"
		else:
			unit = String(char(first_letter + a_position)) + String(char(second_letter + a_position))
	return unit

func to_string():
	var magnitude = expoent / 3
	var unit = get_unit(magnitude)
	var decimalPlaces = 2
	var formatedValue = floor(self.value * pow(10, decimalPlaces)) / pow(10, decimalPlaces)
	#culture invariant
	return String(formatedValue).replace(",", ".") + unit
	
func to_float():
	value = self.value * pow(10, expoent)
	return value

func normalize():
	while self.value >= BigNumberConstants.TEN_CUBED:
		self.value /= BigNumberConstants.CUBED;
		self.expoent += 3
