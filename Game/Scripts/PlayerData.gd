extends RichTextLabel
class_name PlayerData

var SC 
var HC

var networth

func _ready():
	self.SC = BigNumber.new(9, 3)
	self.HC = BigNumber.new(2, 2)
	self.networth = BigNumber.multiply(SC, HC)
	
	print("Value: " + str(networth.value))
	print("Expoent: " + str(networth.expoent))
	bbcode_text = "[center]" + self.SC.to_string() + "[/center]"

