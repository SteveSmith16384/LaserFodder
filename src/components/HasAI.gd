class_name HasAI
extends Spatial

enum AIType {CIV, POLICE, ENEMY_AGENT}
enum Mode {WALK, GUARD}

export(AIType) var ai_type
export var only_move_when_in_view = false

var walk_angle: float # rads
var running = false
var time_until_change_dir : float
var is_in_view = false
var current_mode = Mode.WALK # Default

func _ready():
	self.get_parent().add_to_group("has_ai")
	pass


func get_potential_enemies():
	if ai_type == AIType.POLICE:
		var player_units:Array = get_tree().get_nodes_in_group("player")
		var gang_units:Array = get_tree().get_nodes_in_group("enemy")
		# todo - check if weapon drawn
		player_units.append_array(gang_units)
		return player_units
	elif ai_type == AIType.ENEMY_AGENT:
		var player_units:Array = get_tree().get_nodes_in_group("player")
		return player_units
	else:
		push_error("Invalid type!")
	pass
	
	


func _on_VisibilityNotifier2D_screen_entered():
	is_in_view = true
	pass


func _on_VisibilityNotifier2D_screen_exited():
	is_in_view = false
	pass
