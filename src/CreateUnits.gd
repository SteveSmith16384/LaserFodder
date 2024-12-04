class_name CreateUnits
extends Node

const droid_class = preload("res://EnemyDroid.tscn")
const sterner_class = preload("res://SternerRegnix.tscn")


static func get_droid():
	var droid = droid_class.instance()
	var unit_data:UnitData = droid.get_node("UnitData")
	unit_data.health = 50
	
	return droid
	
	
static func get_sterner():
	var sterner = sterner_class.instance()
	var unit_data:UnitData = sterner.get_node("UnitData")
	unit_data.health = 50
	
	return sterner
	
	
