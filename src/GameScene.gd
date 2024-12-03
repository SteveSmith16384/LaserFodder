extends Spatial

var player_class = preload("res://PlayerUnit.tscn")
var explosion_class = preload("res://Explosion.tscn")

var selected_unit: KinematicBody

var destination_clicked = false
var shoot_clicked = false
var mouse_pos := Vector2()

func _ready():
	# Create players
	var start_positions = $SternersHouse.get_player_start_points()
	for start_position in start_positions:
		_create_player(start_position.global_translation)
		break # todo - remove
		
	EventBus.connect("explosion", self, "_on_explosion")
	
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
				var can_carry = selected_unit.get_node("CanCarry")
				if can_carry.current_item != null:
					if can_carry.current_item.get_node("IsItem").one_off:
						shoot_clicked = false
					var can_shoot = selected_unit.get_node("CanShoot")
					var shot_fired = can_shoot.use_item(can_carry.current_item, result.position)
					if shot_fired:
						selected_unit.shoot_anim()
						selected_unit.emit_signal_equipment_changed()#emit_signal("equipment_changed")
					#print("Shooting!")
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
	var idx = get_tree().get_nodes_in_group("player").size()
	
	var player:Spatial = player_class.instance()
	player.translation = pos
	player.get_node("UnitData").init(Globals.get_unit_name(idx))

	#self.call_deferred("add_child", player)
	$SternersHouse.add_child(player)
	
	var num = get_tree().get_nodes_in_group("player").size()
	player.set_label(num)
	
	$GameUI.add_player_icon(player)

	if selected_unit == null:
		_on_player_selected(player)
	pass


func _on_UI_player_selected(player:KinematicBody):
	_on_player_selected(player)
	pass


func _on_explosion(pos:Vector3):
	var explosion:Spatial = explosion_class.instance()
	explosion.translation = pos
	add_child(explosion)
	
	explosion.connect("finished_changing_map", self, "_on_finished_changing_map")
	pass
	
	
func _on_finished_changing_map():
	$SternersHouse.generate_astar()
	pass
	
	
