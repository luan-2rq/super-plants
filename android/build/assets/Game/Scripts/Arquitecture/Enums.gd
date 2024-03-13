extends Node2D

const Languages = {'en' : 'English', 'pt' : 'Português', 'fr' : 'Français', 'es' : 'Español', 'it': 'Italiano','de' : 'Deutsch', 'ru' : 'Русский', 'tr': 'Türkçe', 'jp' : '日本語', 'kr' : '한국인'}
enum SaveName {player_data, plant_data, root_data, ground_elements_data, train_data, checkpoints_data, collectables_data, settings_data, grow_data, upgrades_data}

enum CurrencyType {HC, SC, AD, Free, IAP}
enum UpgradeType {ProductionRateUpgrade, ProductValueUpgrade, RootGrowthVelocityUpgrade, TrainWagonPayloadCapacityUpgrade}
enum SpecialReward {NoAds, Fertilizer, Multiplier2x, Multiplier3x, Multiplier5x, Multiplier21x}

enum TreeType {Plant, Root}
enum DraggableType {Superficial, Internal}
