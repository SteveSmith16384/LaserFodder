class_name IsGun
extends Node

export var opp_fire = true # todo - use this
export var reload_time_millis:float = 1000
export var damage: float = 1.0
export var burst_size : int = 4
#export var distance: float = 20.0
export var max_ammo:int = 20
export var infinite_ammo = true
export var accuracy:int = 70
export(Resource) var shot_sfx
export(Resource) var bullet_class
export (IsAmmo.AmmoType) var ammo_type: int

var _ammo: int = -1

var time_of_next_shot:float = 0
var num_left_in_burst: int = 3


func get_ammo():
	if infinite_ammo:
		return max_ammo
	if _ammo < 0:
		_ammo = max_ammo
	return _ammo


func dec_ammo():
	if infinite_ammo:
		return
		
	_ammo -= 1
	if _ammo < 0:
		_ammo = 0
	pass
	

func reload():
	_ammo = max_ammo
	pass
	
