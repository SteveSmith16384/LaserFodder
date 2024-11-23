class_name CanMove
extends Spatial

enum Mode {WALK, GUARD}

var speed = 1.65

var walk_angle: float # rads
#var running = false
#var time_until_change_dir : float
var current_mode = Mode.WALK # Default

var destination: Vector3
var patrol_path : Path
var patrol_points
var patrol_index = 0


func _ready():
	self.get_parent().add_to_group("has_ai")
	pass

