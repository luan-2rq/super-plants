extends Resource
class_name PlayerData

#Wallet
var SC : BigNumber
var HC : BigNumber

#Production
var fruit_value : BigNumber
var fruit_production_rate : BigNumber

#Root
var root_growth_velocity
var root_branch_quantity

func _init(SC : BigNumber = null, HC : BigNumber = null):
	self.SC = SC
	self.HC = HC
