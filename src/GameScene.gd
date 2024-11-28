extends Spatial

var player_class = preload("res://PlayerUnit.tscn")

var selected_unit: KinematicBody

#var mouse_clicked_event:InputEventMouseButton
var destination_clicked = false
var shoot_clicked = false
var mouse_pos := Vector2()

func _ready():
	# Create players
	var start_positions = $SternersHouse.get_player_start_points()
	for start_position in start_positions:
		_create_player(start_position.global_translation)
		break # todo - remove
		
	EventBus.connect("player_selected", self, "_on_player_selected")
	EventBus.connect("enemy_selected", self, "_on_enemy_selected")
	
	var players = get_tree().get_nodes_in_group("player")
	_on_player_selected(players[0])
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
	elif Input.is_action_just_pressed("unit_5"):
		var players = get_tree().get_nodes_in_group("player")
		_on_player_selected(players[4])
	pass
	
	
func _physics_process(_delta):
	if selected_unit == null:
		return
			
	if destination_clicked or shoot_clicked or Input.is_action_just_pressed("grenade"):
		var camera = $CameraController/Camera
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000#ray_length
		#print("Click:" + str(to))
		var result = get_world().direct_space_state.intersect_ray(from, to)
		if result.size() > 0:
			if destination_clicked:
				if result.collider.is_in_group("floor"):
					var can_move = selected_unit.get_node("CanMove")
					CanMove.set_destination(selected_unit, can_move, result.position)
					append_log("Destination set")
					destination_clicked = false
			elif shoot_clicked:
				# Shoot!
				var can_shoot = selected_unit.get_node("CanShoot")
				can_shoot.shoot(result.position)
				#print("Shooting!")
			elif Input.is_action_just_pressed("grenade"):
				selected_unit.throw_grenade(result.position)
			pass

	pass
	

func _unhandled_input(event):
	if event is InputEventMouse:
		var ev: InputEventMouse = event
		mouse_pos = ev.global_position
	if event is InputEventMouseButton:# and event.pressed:# and event.button_index == 1:
		var ev: InputEventMouseButton = event
		if ev.button_mask == 1 and ev.button_index == 1:
			destination_clicked = true
		if ev.button_index == 2:
			shoot_clicked = ev.pressed
#		mouse_clicked_event = event

#	if event is InputEventKey:
#		var ev: InputEventKey = event
#		if ev.scancode == KEY_G:
	pass
	
	
func _on_player_selected(player:KinematicBody):
	for pl in get_tree().get_nodes_in_group("player"):
		pl.get_node("SelectedArrow").visible = false
		pl.get_node("IsPlayer").selected = false

	selected_unit = player
	player.get_node("SelectedArrow").visible = true
	player.get_node("IsPlayer").selected = true

	$CameraController.target_aim = player.global_translation
	append_log("Unit selected")
	pass
	

func append_log(s:String):
	$GameUI/Log.append_to_log(s)
	pass
	
	
func _on_enemy_selected(enemy:KinematicBody):
	selected_unit.set_target(enemy)
	append_log("Target selected")
	pass


func _create_player(pos: Vector3):
	var player:Spatial = player_class.instance()
	player.translation = pos
	
	#self.call_deferred("add_child", player)
	$SternersHouse.add_child(player)
	
	var num = get_tree().get_nodes_in_group("player").size()
	player.set_label(num)
	
	$GameUI.add_player_icon(player)
	
	#player.connect("selected", self, "_on_player_selected")
	#player.connect("stats_changed", self, "_on_player_stats_changed")
	#player.connect("equipment_changed", self, "_on_player_equipment_changed")

	if selected_unit == null:
		_on_player_selected(player)
	pass


func _on_UI_player_selected(player:KinematicBody):
	_on_player_selected(player)
	pass


func _on_player_equipment_changed(player):
	$GameUI.update_player_equipment(player)
	pass
	
	
func _on_player_stats_changed(player):
	$GameUI.update_player_stats(player)
	pass
	
