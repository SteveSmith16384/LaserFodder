class_name CreateEquipment
extends Node

const carriedpistol_class = preload("res://CarriedPistol.tscn")
const carriedautogun_class = preload("res://CarriedAutogun.tscn")
const carriedlaspack_class = preload("res://CarriedLasPack.tscn")
const carriedap25grenade_class = preload("res://CarriedAP25Grenade.tscn")
const carriedap50grenade_class = preload("res://CarriedAP50Grenade.tscn")
const carriedap100grenade_class = preload("res://CarriedAP100Grenade.tscn")
const carriedrocketlauncher_class = preload("res://CarriedRocketLauncher.tscn")
const carriedmedikit_class = preload("res://CarriedMediKit.tscn")
const carriedrocket_class = preload("res://CarriedRocket.tscn")

#const ap50grenadeonfloor_class = preload("res://Ap50GrenadeOnFloor.tscn")


static func create_carried_equipment(type: int):
	match type:
		Globals.EquipType.Pistol:
			return carriedpistol_class.instance()
		Globals.EquipType.Autogun:
			return carriedautogun_class.instance()
		Globals.EquipType.AP25:
			return carriedap25grenade_class.instance()
		Globals.EquipType.AP50:
			return carriedap50grenade_class.instance()
		Globals.EquipType.AP100:
			return carriedap100grenade_class.instance()
		Globals.EquipType.MediKit:
			return carriedmedikit_class.instance()
		Globals.EquipType.RocketLauncher:
			return carriedrocketlauncher_class.instance()
		Globals.EquipType.Rocket:
			return carriedrocket_class.instance()
		_:
			push_error("Unknown type:" + str(type))
	pass
	

static func create_dropped_equipment(type: int):
	match type:
		Globals.EquipType.Pistol:
			var eq_class = load("res://PistolOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.Autogun:
			var eq_class = load("res://AutogunOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.AP25:
			var eq_class = load("res://Ap25GrenadeOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.AP50:
			var ap50grenadeonfloor_class = load("res://Ap50GrenadeOnFloor.tscn")
			return ap50grenadeonfloor_class.instance()
		Globals.EquipType.AP100:
			var eq_class = load("res://Ap100GrenadeOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.MediKit:
			var eq_class = load("res://MedikitOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.RocketLauncher:
			var eq_class = load("res://RocketLauncherOnFloor.tscn")
			return eq_class.instance() # todo
		Globals.EquipType.Rocket:
			var eq_class = load("res://RocketOnFloor.tscn")
			return eq_class.instance() # todo
		_:
			push_error("Unknown type:" + str(type))
			return null
	pass


static func get_item_name(type:int) -> String:
	match type:
		Globals.EquipType.Pistol:
			return "Pistol"
		Globals.EquipType.Autogun:
			return "Autogun"
		Globals.EquipType.AP25:
			return "AP25 Grenade"
		Globals.EquipType.AP50:
			return "AP50 Grenade"
		Globals.EquipType.AP100:
			return "AP100 Grenade"
		Globals.EquipType.MediKit:
			return "Medikit"
		Globals.EquipType.RocketLauncher:
			return "Rocket Launcher"
		Globals.EquipType.Rocket:
			return "Rocket"
		_:
			push_error("Unknown type:" + str(type))
			return "nulUnknown"
	pass
	
	
