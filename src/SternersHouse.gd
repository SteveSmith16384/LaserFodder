extends Spatial

func _ready():
	$GenerateAStar.generate_astar(1.6)#3.2)#1.6, -8, 34, 25, 3.2)

	place_droids()
	place_sterner()
	pass


func place_droids():
	var droid_start_positions = $DroidStartPositions
	var droids = get_tree().get_nodes_in_group("droid")
	for droid in droids:
		var idx = Globals.rnd.randi_range(0, droid_start_positions.get_child_count()-1)
		droid.translation = droid_start_positions.get_child(idx).translation;
		droid_start_positions.remove_child(droid_start_positions.get_child(idx))
	pass


func place_sterner():
	var sterner_start_positions = $SternerStartPositions
	var idx = Globals.rnd.randi_range(0, sterner_start_positions.get_child_count()-1)
	$Units/SternerRegnix.translation = sterner_start_positions.get_child(idx).translation;
	pass


func get_rnd_destination():
	var points = $RoutePoints
	var dest = points.get_node("RoutePoint" + str(Globals.rnd.randi_range(1, points.get_child_count())))
	return dest.translation
	

func get_route(start, end):
	var route = $Navigation.get_simple_path(start, end)
	if route.size() == 0:
		print("No route!")
	route.append(end)
	return route


func get_player_start_points():
	return $PlayerStartPositions.get_children()
	
	
