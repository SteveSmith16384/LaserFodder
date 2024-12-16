class_name CreateEquipment
extends Node

enum EquipType { Pistol, Autogun, AP25, AP50, AP100, MediKit, RocketLauncher, Rocket }

const carriedpistol_class = preload("res://CarriedPistol.tscn")
const carriedautogun_class = preload("res://CarriedAutogun.tscn")
const carriedlaspack_class = preload("res://CarriedLasPack.tscn")
const carriedap25grenade_class = preload("res://CarriedAP25Grenade.tscn")
const carriedap50grenade_class = preload("res://CarriedAP50Grenade.tscn")
const carriedap100grenade_class = preload("res://CarriedAP100Grenade.tscn")
const carriedrocketlauncher_class = preload("res://CarriedRocketLauncher.tscn")
const carriedmedikit_class = preload("res://CarriedMediKit.tscn")
const carriedrocket_class = preload("res://CarriedRocket.tscn")


static func get_equipment(type: int):
	match type:
		EquipType.Pistol:
			return carriedpistol_class.instance()
		EquipType.Autogun:
			return carriedautogun_class.instance()
		EquipType.AP25:
			return carriedap25grenade_class.instance()
		EquipType.AP50:
			return carriedap50grenade_class.instance()
		EquipType.AP100:
			return carriedap100grenade_class.instance()
		EquipType.MediKit:
			return carriedmedikit_class.instance()
		EquipType.RocketLauncher:
			return carriedrocketlauncher_class.instance()
		EquipType.Rocket:
			return carriedrocket_class.instance()
		_:
			push_error("Unknown type:" + str(type))
			
			
