class_name CanMove
extends Spatial

const debuggingsphere_class = preload("res://DebuggingSphere.tscn")
const destarrow_class = preload("res://Ring.tscn")

export var show_destination = false

var speed = 1.65

var has_destination = false
var route_points : PoolVector3Array 
var route_index = 0
var pause_for : float = 0
var prev_pos := Vector3()
var route_polygon:CSGPolygon

func _ready():
	route_polygon = $RoutePolygon_GETS_MOVED#.duplicate(0)
	self.remove_child($RoutePolygon_GETS_MOVED)
	if show_destination:
#		dest_arrow = destarrow_class.instance()
#		dest_arrow.visible = false
#		dest_arrow.modulate = Color.green
#		get_parent().get_parent().call_deferred("add_child", dest_arrow)

		get_parent().get_parent().call_deferred("add_child", route_polygon)
	pass
	

# todo - why is this static?
static func set_destination(player:Spatial, can_move, dest: Vector3):
	dest.y = 0
	var start_point:int = Globals.astar.get_closest_point(player.translation)
	var end_point:int = Globals.astar.get_closest_point(dest)
	can_move._set_dest(Globals.astar.get_point_path(start_point, end_point), dest)
	pass
	
	
func _set_dest(route_points_, dest:Vector3):
	route_points = route_points_
	if route_points.size() > 0:
		route_points.push_back(dest) # Add point clicked!  todo - doesn't work!
		
		route_index = 0
		if route_points.size() > 1:
			var array = [route_points]
			var pool_array = array[0]
			#pool_array.push_front(get_parent().translation) # Add start pos
			pool_array.push_back(dest) # add and pos
			route_points = pool_array

		has_destination = true
#		if can_move.dest_arrow != null:
#			can_move.dest_arrow.visible = true
#			can_move.dest_arrow.translation = pos
#			can_move.dest_arrow.translation.y = .01
		
		if show_destination:
			set_path()
			
#		if Globals.SHOW_ASTAR_ROUTE:
#			for t in Globals.to_remove:
#				t.queue_free()
#			Globals.to_remove.clear()
#
#			for p in route_points:
#				var debug:Spatial = debuggingsphere_class.instance()
#				debug.translation = p
#				player.get_parent().add_child(debug)
#				Globals.to_remove.push_back(debug)

		prev_pos = Vector3() # So they can start moving without being paused
		
	else:
		has_destination = false
#		dest_arrow.visible = false
	pass


func set_path():
	var curve = Curve3D.new()
	curve.bake_interval = 1
	for p in route_points:
		p.y = 0.2
		curve.add_point(p)
	
	var path:Path = route_polygon.get_node("Path")
	path.curve = curve
	route_polygon.path_node = path.get_path()
	route_polygon.visible = true
	pass


func set_route_colour(col:Color):
#	if route_polygon != null:
	var mat: SpatialMaterial = route_polygon.material
	mat.albedo_color = col
	pass
	
