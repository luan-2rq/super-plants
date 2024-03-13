extends Resource
class_name StoreItemConfig

@export var title_locale_key : String
@export var description_locale_key : String

@export var id : String

#Rewards
@export var special_rewards : Array[Enums.SpecialReward]
@export var HC: BigNumber
@export var SC: BigNumber

#Payment
@export var payment_type : Enums.CurrencyType
@export var payment_value: BigNumber
