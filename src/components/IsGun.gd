extends Node

export var opp_fire = true # todo - use this
export var reload_time:float = 1.0
export var damage: float = 1.0
#export var distance: float = 20.0
export var max_ammo:int = 20
export var accuracy:int = 90
export(Resource) var shot_sfx
export(Resource) var bullet_class

var _ammo: int = -1

func get_ammo():
	if _ammo < 0:
		_ammo = max_ammo
	return 10 # _ammo


func dec_ammo():
	_ammo -= 1
	if _ammo < 0:
		_ammo = 0
	pass
	
