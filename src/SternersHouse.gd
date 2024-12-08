extends Spatial

func _ready():
	generate_astar()
	
	place_droids()
	place_sterner()
	pass


func generate_astar():
	$GenerateAStar.generate_astar(1.6)
	pass
	

func place_droids():
	var droid_start_positions = $DroidStartPositions
	for i in 5:
		var droid:KinematicBody = CreateUnits.get_droid()
		droid.get_node("UnitData").init("Droid " + str(i), Globals.SIDE_STERNER)
		var idx = Globals.rnd.randi_range(0, droid_start_positions.get_child_count()-1)
		droid.translation = droid_start_positions.get_child(idx).global_translation;
		droid_start_positions.remove_child(droid_start_positions.get_child(idx))
		self.add_child(droid)
	pass


func place_sterner():
	var sterner:KinematicBody = CreateUnits.get_sterner() #sterner_class.instance()
	sterner.get_node("UnitData").init("Sterner Regnix", Globals.SIDE_STERNER)
	var sterner_start_positions = $SternerStartPositions
	var idx = Globals.rnd.randi_range(0, sterner_start_positions.get_child_count()-1)
	sterner.translation = sterner_start_positions.get_child(idx).global_translation;
	self.add_child(sterner)
	pass


func get_rnd_destination():
	var points = $RoutePoints
	var dest = points.get_node("RoutePoint" + str(Globals.rnd.randi_range(1, points.get_child_count())))
	return dest.global_translation
	

func get_route(start, end):
	var route = $Navigation.get_simple_path(start, end)
	if route.size() == 0:
		print("No route!")
	route.append(end)
	return route


func get_player_start_points():
	return $PlayerStartPositions.get_children()
	

