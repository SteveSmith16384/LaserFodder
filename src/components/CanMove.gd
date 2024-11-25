class_name CanMove
extends Spatial

const debuggingsphere_class = preload("res://DebuggingSphere.tscn")

enum Mode {WALK, GUARD}

var speed = 1.65

#var walk_angle: float # rads
#var running = false
#var time_until_change_dir : float
var current_mode = Mode.WALK # Default

#var next_destination: Vector3
#var final_destination: Vector3
#var route_path : Path
var has_destination = false
var route_points : PoolVector3Array 
var route_index = 0

func _ready():
#	self.get_parent().add_to_group("can_move")
	pass


static func set_destination(player:Spatial, can_move, pos: Vector3):
	pos.y = 0
	var start_point:int = Globals.astar.get_closest_point(player.translation)
	var end_point:int = Globals.astar.get_closest_point(pos)
	can_move.route_points = Globals.astar.get_point_path(start_point, end_point)
	if can_move.route_points.size() > 2:
		can_move.route_index = 1 # todo?
		can_move.has_destination = true
		
		for t in Globals.to_remove:
			t.queue_free()
		Globals.to_remove.clear()
		
		for p in can_move.route_points:
			var debug:Spatial = debuggingsphere_class.instance()
			debug.translation = p
			player.get_parent().add_child(debug)
			Globals.to_remove.push_back(debug)
	else:
		can_move.has_destination = false

#	if clear_target:
#		can_shoot.current_target = null # Otherwise they won't move until they've killed the target
	pass


