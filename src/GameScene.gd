extends Spatial

var player_class = preload("res://PlayerUnit.tscn")

var selected_units: Array
var mouse_clicked_event:InputEventMouseButton

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("unit_1"):
		var players = get_tree().get_nodes_in_group("player")
		_on_player_selected(players[0])
	elif Input.is_action_just_pressed("unit_2"):
		var players = get_tree().get_nodes_in_group("player")
		_on_player_selected(players[1])
	elif Input.is_action_just_pressed("unit_3"):
		var players = get_tree().get_nodes_in_group("player")
		_on_player_selected(players[2])
	elif Input.is_action_just_pressed("unit_4"):
		var players = get_tree().get_nodes_in_group("player")
		_on_player_selected(players[3])
	pass
	
	
func _physics_process(_delta):
	if mouse_clicked_event != null:
		if mouse_clicked_event.button_index != 1:
			return
			
		var camera = $CameraController/Camera
		var from = camera.project_ray_origin(mouse_clicked_event.position)
		var to = from + camera.project_ray_normal(mouse_clicked_event.position) * 1000#ray_length
		#print("Click:" + str(to))
		var result = get_world().direct_space_state.intersect_ray(from, to)
		if result.size() > 0:
			if result.collider == $City/Floor:
				var offset_idx : int = 0
				for unit in selected_units:
					unit.set_destination(result.position, true, offset_idx > 0)
					append_log("Destination set")
					offset_idx += 1
			pass
		mouse_clicked_event = null
	pass
	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:# and event.button_index == 1:
		mouse_clicked_event = event
	pass
	
	
func _on_player_selected(player):
	for pl in get_tree().get_nodes_in_group("player"):
		pl.get_node("SelectedArrow").visible = false

	selected_units.clear()
	selected_units.push_back(player)
	player.get_node("SelectedArrow").visible = true

	$CameraController.target_aim = player
	append_log("Unit selected")
	pass
	

func append_log(s:String):
	$UI/Log.append_to_log(s)
	pass
	
	
func _on_enemy_selected(enemy:KinematicBody):
	append_log("Target selected")
	for unit in selected_units:
		unit.set_target(enemy)
	pass


func _on_City_create_player(pos: Vector3):
	var player:Spatial = player_class.instance()
	player.translation = pos
	
	#self.call_deferred("add_child", player)
	self.add_child(player)
	
	var num = get_tree().get_nodes_in_group("player").size()
	player.set_label(num)
	
	$UI.add_player_icon(player)
	
	player.connect("selected", self, "_on_player_selected")
	player.connect("stats_changed", self, "_on_player_stats_changed")
	player.connect("equipment_changed", self, "_on_player_equipment_changed")

	if selected_units.size() == 0:
		_on_player_selected(player)
	pass


func _on_UI_player_selected(player:KinematicBody):
	_on_player_selected(player)
	pass


func _on_UI_select_all():
	selected_units = get_tree().get_nodes_in_group("player")

	for pl in get_tree().get_nodes_in_group("player"):
		pl.get_node("SelectedArrow").visible = true
	pass


func _on_player_equipment_changed(player):
	$UI.update_player_equipment(player)
	pass
	
	
func _on_player_stats_changed(player):
	$UI.update_player_stats(player)
	pass
	
