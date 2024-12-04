class_name UnitData
extends Node

signal shot
signal killed

var unit_name: String
var armour : float = 50 # Reduces damage by this percent
var max_health : float = 100
var health : float = 100
var killed = false

func init(name: String):
	unit_name = name
	pass


func dec_health(shooter:Spatial, amt:float):
	amt = amt * armour / 100
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
	get_parent().emit_signal("health_changed")
	pass
	
	
