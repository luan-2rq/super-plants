extends Resource
class_name StoreItemConfig

@export var title_locale_key : String
@export var description_locale_key : String

@export var id : String

#Rewards
@export var special_rewards : Array # (Array, Enums.SpecialReward)
@export var HC: Resource #:BigNumber
@export var SC: Resource #:BigNumber

#Payment
@export var payment_type : int # (Enums.CurrencyType)
@export var payment_value: Resource #:BigNumber
