extends Spatial

var player_class = preload("res://PlayerUnit.tscn")
var explosion_class = preload("res://Explosion.tscn")

var selected_unit: KinematicBody

var destination_clicked = false
var shoot_clicked = false
var mouse_pos := Vector2()

var units_left_to_deploy = 5

func _ready():
	EventBus.connect("explosion", self, "_on_explosion")
	EventBus.connect("player_selected", self, "_on_player_selected")

	append_log("Select location for unit " + str(6-units_left_to_deploy))
	pass


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		_set_pause(not Globals.game_paused)
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
	elif Input.is_action_just_pressed("reload"):
		_reload()
	pass
	
	
func _physics_process(delta):
	if Globals.game_stage == Globals.GameStage.DEPLOYMENT:
		_physics_process_deploy(delta)
	elif Globals.game_stage == Globals.GameStage.IN_GAME:
		_physics_process_in_game(delta)
	pass
	

func _physics_process_deploy(_delta):
#	if mouse_pos.x > 612:
#	$CameraController.adj_target_aim((mouse_pos.x - 612) * delta * 0.1, 0)
#	else:
#		$CameraController.adj_target_aim(mouse_pos.x - 612)
	
	if destination_clicked:
		destination_clicked = false

		var camera = $CameraController/Camera
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		#print("Click:" + str(to))
		var result = get_world().direct_space_state.intersect_ray(from, to)
		if result.size() > 0:
			if result.collider.is_in_group("floor"):
				_create_player(result.position)
				units_left_to_deploy -= 1
				if units_left_to_deploy <= 0:
					_start_game()
				else:
					append_log("Select location for unit " + str(6-units_left_to_deploy))
	pass
	
	
func _physics_process_in_game(_delta):
	if selected_unit == null:
		return
		
	var pos = selected_unit.global_translation
	pos.z += 4.0
	if mouse_pos.y > 130:
		pos.x += (mouse_pos.x - 612)/35
		pos.z += (mouse_pos.y - 300)/35
	$CameraController.set_target_aim(pos)
		
	var unit_data: UnitData = selected_unit.get_node("UnitData")
	if unit_data.killed:
		return

	if destination_clicked or shoot_clicked:
		var camera = $CameraController/Camera
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
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
					if can_carry.current_item.get_node("IsItem").one_off_shot:
						shoot_clicked = false
					var can_shoot = selected_unit.get_node("CanUseItem")
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
	pass
	

func _start_game():
	Globals.game_stage = Globals.GameStage.IN_GAME

	var players = get_tree().get_nodes_in_group("player")
	_on_player_selected(players[0])

	$CameraController.set_target_aim(selected_unit.global_translation)
	
	append_log("MISSION STARTED!")
	append_log("Press P to pause the action")
	pass
	
	
func _on_player_selected(player:KinematicBody):
	for pl in get_tree().get_nodes_in_group("player"):
		pl.deselected()

	var unit_data: UnitData = player.get_node("UnitData")
	if unit_data.killed:
		append_log("That unit is dead")
		return
		
	selected_unit = player

	player.selected()
#	$CameraController.target_aim = player.global_translation
#	$CameraController.target_aim.z += 7
	append_log("Unit selected")
	
	$GameUI.select_player(player)
	pass
	

func append_log(s:String):
	$GameUI/Log.append_to_log(s)
	pass
	
	
# todo - is this used?
func _on_enemy_selected(enemy:KinematicBody):
	selected_unit.set_target(enemy)
	append_log("Target selected")
	pass


func _create_player(pos: Vector3):
	var idx = get_tree().get_nodes_in_group("player").size()
	
	var player:Spatial = player_class.instance()
	player.translation = pos
	player.get_node("UnitData").init(Globals.get_unit_name(idx), Globals.SIDE_PLAYER)

	player.connect("health_changed", self, "_on_player_health_changed")
	$SternersHouse.add_child(player)
	
	var num = get_tree().get_nodes_in_group("player").size()
	player.set_label(num)
	
	$GameUI.add_player_icon(player)
	pass


func _on_UI_player_selected(player:KinematicBody):
	_on_player_selected(player)
	pass


func _on_explosion(pos:Vector3, rad:float, dmg:float):
	var explosion:Spatial = explosion_class.instance()
	explosion.init(rad, dmg)
	explosion.translation = pos
	add_child(explosion)
	
	explosion.connect("finished_changing_map", self, "_on_finished_changing_map")
	pass
	
	
func _on_finished_changing_map():
	$SternersHouse.generate_astar()
	pass


func _on_GameUI_pause_changed(button_pressed):
	_set_pause(button_pressed)
	pass
	
	
func _set_pause(b:bool):
	Globals.game_paused = b
	$GameUI/Commands/PauseButton.set_pressed_no_signal(b)
	if Globals.game_paused:
		append_log("Game paused")
	else:
		append_log("Game unpaused")
	pass


func _on_player_health_changed(player):
	var unit_data: UnitData = player.get_node("UnitData")
	if unit_data.killed:
#		if player == selected_unit:
#			selected_unit = null
		append_log(unit_data.unit_name + " HAS BEEN KILLED!")
	pass
	
	
func _reload():
	var can_carry:CanCarry = selected_unit.get_node("CanCarry")
	var gun:IsGun = can_carry.current_item.find_node("IsGun", false)
	if gun == null:
		return
		
	if gun.get_ammo() >= gun.max_ammo:
		append_log("Weapon already at full ammo")
		return
		
	for item in can_carry.items:
		var ammo = item.find_node("IsAmmo", false)
		if ammo == null:
			continue
		if ammo.ammo_type != gun.ammo_type:
			continue
		
		gun.reload()
		can_carry.items.erase(item)
		append_log("Weapon reloaded")
		# todo - player can't shoot until reload time
		selected_unit.emit_signal_equipment_changed()
		break
	pass
	
	
