extends Resource
class_name StoreItemConfig

export var title_locale_key : String
export var description_locale_key : String

export var id : String

#Rewards
export(Array, Enums.SpecialReward) var special_rewards : Array
export(Resource) var HC : Resource #:BigNumber
export(Resource) var SC : Resource #:BigNumber

#Payment
export(Enums.CurrencyType) var payment_type : int
export(Resource) var payment_value #:BigNumber
