class_name UnitData
extends Node

signal shot
signal killed

var unit_name: String
var side: int
var armour : float = 50.0 # Reduces damage by this percent
var max_health : float = 100
var health : float = 100
var accuracy : float = 70
var killed = false
var time_until_target_check: float

# Player data
var action_mode:  int = 0

# Droid data
var guard : bool = true

func init(name: String, side_:int):
	unit_name = name
	side = side_
	if Globals.rnd.randi_range(1, 2) == 1:
		guard = false
	pass


func dec_health(shooter:Spatial, amt:float):
	amt = amt * armour / 100.0
	health -= amt
	if health <= 0:
		killed = true
		get_parent().get_node("CollisionShape").disabled = true
		emit_signal("killed", shooter)
	else:
		emit_signal("shot", shooter)
	pass
	

func reset_health():
	health = max_health
	get_parent().emit_signal("health_changed", get_parent())
	pass
	
	
