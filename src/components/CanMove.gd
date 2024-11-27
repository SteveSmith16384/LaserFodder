class_name CanMove
extends Spatial

const debuggingsphere_class = preload("res://DebuggingSphere.tscn")

enum Mode {WALK, GUARD}

var speed = 1.65

var current_mode = Mode.WALK # Default

var has_destination = false
var route_points : PoolVector3Array 
var route_ids # todo - remove
var route_index = 0
var pause_for : float = 0

static func set_destination(player:Spatial, can_move, pos: Vector3):
	pos.y = 0
	var start_point:int = Globals.astar.get_closest_point(player.translation)
	var end_point:int = Globals.astar.get_closest_point(pos)
	can_move.route_points = Globals.astar.get_point_path(start_point, end_point)
	if can_move.route_points.size() > 0:
		can_move.route_points.push_back(pos) # Add point clicked!
		
		can_move.route_ids = Globals.astar.get_id_path(start_point, end_point)

		can_move.route_index = 0
		if can_move.route_points.size() > 1:
			can_move.route_index = 1 # First point is sometimes in the wrong direction

		can_move.has_destination = true
		
		if Globals.SHOW_ASTAR_ROUTE:
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


