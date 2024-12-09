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
#var dest_arrow: Spatial

onready var route_polygon = $RoutePolygon


func _ready():
	self.remove_child(route_polygon)
	if show_destination:
#		dest_arrow = destarrow_class.instance()
#		dest_arrow.visible = false
#		dest_arrow.modulate = Color.green
#		get_parent().get_parent().call_deferred("add_child", dest_arrow)

		get_parent().get_parent().call_deferred("add_child", route_polygon)
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
#		if can_move.dest_arrow != null:
#			can_move.dest_arrow.visible = true
#			can_move.dest_arrow.translation = pos
#			can_move.dest_arrow.translation.y = .01
		
		if can_move.show_destination:
			can_move.set_path()
			
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


func set_path():
	var curve = Curve3D.new()
	curve.bake_interval = 1
	for p in route_points:
		p.y = 0.2
		curve.add_point(p)
	
	var path:Path = route_polygon.get_node("Path")#Path.new()
	path.curve = curve
	route_polygon.path_node = path.get_path()
	route_polygon.visible = true
	pass

