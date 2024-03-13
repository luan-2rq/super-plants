extends Resource
class_name UpgradeConfig

@export var upgrade_type : Enums.UpgradeType # (Enums.UpgradeType)
@export var title_locale_key : String
@export var description_locale_key : String

#Balancing
@export var percentage_factor : float
@export var increase : bool

#Big Number: Initial Price
@export var initial_price_significant : float
@export var initial_price_exp : int

@export var price_percentage_factor : float

@export var max_upgrades : int

