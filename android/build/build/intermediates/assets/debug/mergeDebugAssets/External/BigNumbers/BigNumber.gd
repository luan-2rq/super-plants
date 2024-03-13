extends Resource
class_name BigNumber

#GODOT LIMITATION
const script_path = "res://External/BigNumbers/BigNumber.gd"

@export var value : float
@export var expoent : int

const UNITS : Array = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "UDc", "DDc", "TDc","QaDc", "QiDc", "SxDc", "SpDc", "ODc", "NDc", "Vg", "UVg", "DVg", "TVg", "QaVg", "QiVg", "SxVg", "SpVg", "OVg", "NVg", "Tg", "UTg", "DTg", "TTg", "QaTg", "QiTg", "SxTg", "SpTg", "OTg", "NTg", "Qd", "UQd", "DQd", "TQd", "QaQd", "QiQd", "SxQd", "SpQd", "OQd", "NQd", "Qq", "UQq", "DQq", "TQq", "QaQq", "QiQq", "SxQq", "SpQq", "OQq", "NQq", "Sx", "USx", "DSx", "TSx", "QaSx", "QiSx", "SxSx", "SpSx", "OSx", "NSx", "Sp", "USp", "DSp", "TSp", "QaSp", "QiSp", "SxSp", "SpSp", "OSp", "NSp", "Oc", "UOc", "DOc", "TOc", "QaOc", "QiOc", "SxOc", "SpOc", "OOc", "NOc", "No", "UNo", "DNo", "TNo", "QaNo", "QiNo", "SxNo", "SpNo", "ONo", "NNo", "Ce", "UCe", "DCe", "TCe", "QaCe", "QiCe", "SxCe", "SpCe", "OCe"]
const DISTANCE_UNITS : Array = ["m", "km", "Mm", "Gm", "Tm", "Pm", "Em", "Zm", "Ym", "Nm", "Dm", "UDm", "DDm", "TDm", "QaDm", "QiDm", "SxDm", "SpDm", "ODm", "NDm", "Vg", "UVg", "DVg", "TVg", "QaVg", "QiVg", "SxVg", "SpVg", "OVg", "NVg", "Tg", "UTg", "DTg", "TTg", "QaTg", "QiTg", "SxTg", "SpTg", "OTg", "NTg", "Qd", "UQd", "DQd", "TQd", "QaQd", "QiQd", "SxQd", "SpQd", "OQd", "NQd", "Qq", "UQq", "DQq", "TQq", "QaQq", "QiQq", "SxQq", "SpQq", "OQq", "NQq", "Sx", "USx", "DSx", "TSx", "QaSx", "QiSx", "SxSx", "SpSx", "OSx", "NSx", "Sp", "USp", "DSp", "TSp", "QaSp", "QiSp", "SxSp", "SpSp", "OSp", "NSp", "Oc", "UOc", "DOc", "TOc", "QaOc", "QiOc", "SxOc", "SpOc", "OOc", "NOc", "No", "UNo", "DNo", "TNo", "QaNo", "QiNo", "SxNo", "SpNo", "ONo", "NNo", "Ce", "UCe", "DCe", "TCe", "QaCe", "QiCe", "SxCe", "SpCe", "OCe"]
const TEN_CUBED = 1000
const MAX_EXP_DIFFERENCE = 12

func _init(value: float = 0, expoent : int = 1):
	self.value = value
	self.expoent = expoent
	normalize()
	
static func align(a : BigNumber, b: BigNumber):
	if a.expoent > b.expoent:
		var expoent_difference: int = a.expoent - b.expoent
		if expoent_difference > 0:
			b.value = b.value / pow(10, expoent_difference) if (expoent_difference <= MAX_EXP_DIFFERENCE) else 0.0
			b.expoent = a.expoent
	else:
		var expoent_difference: int = b.expoent - a.expoent
		if expoent_difference > 0:
			a.value = a.value / pow(10, expoent_difference) if (expoent_difference <= MAX_EXP_DIFFERENCE) else 0.0
			a.expoent = b.expoent
	
func multiply(b : BigNumber):
	var copyB = load(script_path).new(b.value, b.expoent)
	align(self, copyB)
	self.value = self.value * copyB.value
	self.expoent = self.expoent + b.expoent
	normalize()
	
func divide(b : BigNumber):
	var copyB = load(script_path).new(b.value, b.expoent)
	align(self, copyB)
	self.value = self.value / copyB.value
	self.expoent = self.expoent - b.expoent
	normalize()

func sum(b : BigNumber):
	var copyB = load(script_path).new(b.value, b.expoent)
	align(self, copyB)
	self.value = self.value + copyB.value
	normalize()

func subtract(b : BigNumber):
	var copyB = load(script_path).new(b.value, b.expoent)
	align(self, copyB)
	self.value = self.value - copyB.value
	self.expoent = self.expoent
	normalize()

func power(b : float):
	self.value = pow(self.value, b)
	self.expoent *= b
	normalize()
	
func equal(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA,  copyB)
	return copyA.value == copyB.value
		
func different(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA, copyB)
	return copyA.value != copyB.value
	
func greater_than(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA, copyB)
	return copyA.value > copyB.value
	
func greater_or_equal_than(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA, copyB)
	return copyA.value >= copyB.value
		
func less_than(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA, copyB)
	return copyA.value < copyB.value
		
func less_or_equal_than(b : BigNumber):
	var copyA
	var copyB
	copyA = load(script_path).new(self.value, self.expoent)
	copyB = load(script_path).new(b.value, b.expoent)
	align(copyA, copyB)
	return copyA.value <= copyB.value

func get_unit(magnitude: int) -> String:
	var unit: String
	var letters_in_the_alphabet = 26
	var a_position = 65
	if magnitude < UNITS.size():
		unit = UNITS[magnitude]
	else:
		var magnitude_difference = magnitude - UNITS.size()
		#defining the letters of the unit symbol
		var second_letter = magnitude_difference % letters_in_the_alphabet
		var first_letter = magnitude_difference / letters_in_the_alphabet
		if first_letter > 26:
			unit = " a lot"
		else:
			unit = String(char(first_letter + a_position)) + String(char(second_letter + a_position))
	return unit

#To do: only show decimal places when decimal part is bigger than 0
func to_str(decimal_places : int = 2):
	var unit = 0
	var formatted_value = 0
	if expoent >= 3:
		var magnitude = expoent / 3
		unit = get_unit(magnitude)
		formatted_value = ("%0." + str(decimal_places) + "f") % (self.value * pow(10, expoent - magnitude * 3))
	else:
		unit = get_unit(0)
		formatted_value = ("%0." + str(decimal_places) + "f") % (self.value * pow(10, expoent))
	#culture invariant
	return formatted_value.replace(",", ".") + unit
	
func to_float():
	var float_value = self.value * pow(10, expoent)
	return float_value

func normalize():
	while self.value >= TEN_CUBED:
		self.value /= TEN_CUBED
		self.expoent += 3
