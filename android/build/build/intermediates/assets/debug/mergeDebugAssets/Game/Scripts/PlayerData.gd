extends Resource
class_name PlayerData

#Wallet
@export var SC : BigNumber
@export var HC : BigNumber

#Production
@export var fruit_value : BigNumber
@export var fruit_production_rate : BigNumber

#Root
@export var root_growth_velocity : float
@export var root_branch_quantity : float

func _init(SC : BigNumber = null, HC : BigNumber = null):
	self.SC = SC
	self.HC = HC
