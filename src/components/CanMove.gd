class_name CanMove
extends Spatial

const debuggingsphere_class = preload("res://DebuggingSphere.tscn")
const destarrow_class = preload("res://Ring.tscn")

export var show_destination = false

var speed = 1.65

var has_destination = false
var route_points : PoolVector3Array 
#var route_ids # todo - for debugging - remove
var route_index = 0
var pause_for : float = 0
var dest_arrow: Spatial
var path: Curve

func _ready():
	if show_destination:
		dest_arrow = destarrow_class.instance()
		dest_arrow.visible = false
		dest_arrow.modulate = Color.green
		get_parent().get_parent().call_deferred("add_child", dest_arrow)
	pass
	
	
static func set_destination(player:Spatial, can_move, pos: Vector3):
	pos.y = 0
	var start_point:int = Globals.astar.get_closest_point(player.translation)
	var end_point:int = Globals.astar.get_closest_point(pos)
	can_move.route_points = Globals.astar.get_point_path(start_point, end_point)
	if can_move.route_points.size() > 0:
		can_move.route_points.push_back(pos) # Add point clicked!
		
		# For debbugging:
		#can_move.route_ids = Globals.astar.get_id_path(start_point, end_point)

		can_move.route_index = 0
		if can_move.route_points.size() > 1:
			can_move.route_index = 1 # First point is sometimes in the wrong direction

		can_move.has_destination = true
		if can_move.dest_arrow != null:
			can_move.dest_arrow.visible = true
			can_move.dest_arrow.translation = pos
			can_move.dest_arrow.translation.y = .01
		
		if can_move.show_destination:
			player.set_path()
			
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
		can_move.dest_arrow.visible = false
	pass


