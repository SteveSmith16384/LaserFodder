class_name HasAI
extends Spatial

enum Mode {WALK, GUARD}

var walk_angle: float # rads
#var running = false
var time_until_change_dir : float
var current_mode = Mode.WALK # Default

func _ready():
	self.get_parent().add_to_group("has_ai")
	pass


#func get_potential_enemies():
#	var player_units:Array = get_tree().get_nodes_in_group("player")
#	pass
	
