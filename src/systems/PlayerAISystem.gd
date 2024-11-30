extends Node

const SPEED = 3#1.65
const ENEMY_TARGET_CHECK_INTERVAL :int = 1

signal equipment_changed

func _physics_process(delta):
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		_process_player(player, delta)
	pass
	

func _process_player(player:KinematicBody, delta:float):
	var can_be_shot = player.get_node("CanBeShot")

	if can_be_shot.killed:
		# We're dead
		return

	var is_player = player.get_node("IsPlayer")
	var can_move = player.get_node("CanMove")
	var can_shoot = player.get_node("CanShoot")
	
	if can_shoot.current_target != null:
		if is_instance_valid(can_shoot.current_target) == false:
			# Target is dead
			can_shoot.current_target = null
			return
		var cbs = can_shoot.current_target.get_node("CanBeShot")
		if cbs.killed:
			# Target is dead
			can_shoot.current_target = null
			return
			
		var can_see = player.can_see_target(can_shoot.current_target)
		if can_see:
			#player.turn_to_face(can_shoot.current_target)
			
			#var dist = self.global_translation.distance_to($CanShoot.current_target.global_translation)
			#var is_gun = $CanShoot.current_weapon.get_node("IsGun")
#			if dist < is_gun.distance:
#			if is_player.selected == false:
#				can_move.has_destination = false
			var shot_fired = can_shoot.shoot(can_shoot.current_target.global_translation)
			if shot_fired:
				player.shoot_anim()
				emit_signal("equipment_changed", self)
#			return
#			else:
#				# Walk towards them
#				set_destination($CanShoot.current_target.translation, false)
		else:
			# Walk towards them - todo?
			#set_destination(can_move, can_shoot.current_target.translation, false)
			pass
	else:
		if is_player.selected == false: # Only auto-select target if not selected
			if can_shoot.time_until_target_check <= 0:
				_check_for_enemy(player, can_shoot)
				can_shoot.time_until_target_check = ENEMY_TARGET_CHECK_INTERVAL
				pass
		
	if can_move.has_destination == false:
		return
	
	if can_move.pause_for > 0:
		player.idle_anim()
		can_move.pause_for -= delta
		return
		
	var next_dest: Vector3 = can_move.route_points[can_move.route_index]
	
	if can_move.route_index + 1 < can_move.route_points.size():
		# Can we see ahead?
		if player.can_see_point(can_move.route_points[can_move.route_index+1]):
			can_move.route_index += 1
			next_dest = can_move.route_points[can_move.route_index]
			
	next_dest.y = player.translation.y

	var dir:Vector3 = next_dest - player.translation
	if dir.length() < .2: # Reached point
		can_move.route_index += 1
		if can_move.route_index >= can_move.route_points.size():
			 # Reached destination
			_stop_walking(player, can_move)
		return # Loop around next time
		
	var offset :Vector3 = dir.normalized() * SPEED
	var old_pos:= Vector2(player.translation.x, player.translation.z)
	player.move_and_slide(offset)
		
	# Rotate based on new position
	var new_pos:= Vector2(player.translation.x, player.translation.z)
	var ang:float = old_pos.angle_to_point(new_pos)
	player.get_node("Rotator").rotation.y = -ang

	player.walk_anim()
	pass
	

func _check_for_enemy(entity, can_shoot):
	var closest: KinematicBody = null
	var closest_dist: float = 9999
	
	var enemy_units = get_tree().get_nodes_in_group("enemy")
	for enemy_unit in enemy_units:
		var can_see:bool = entity.can_see_target(enemy_unit)
		if can_see:
			var cbs = enemy_unit.get_node("CanBeShot")
			if cbs.killed:
				continue
			# check distance
			var dist = entity.global_translation.distance_to(enemy_unit.global_translation)
#			if dist > Globals.AI_VIEW_DISTANCE:
#				continue
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy_unit
				
	can_shoot.current_target = closest
	pass


func _stop_walking(player, can_move):
	can_move.has_destination = false
	can_move.dest_arrow.visible = false
	player.idle_anim()
	pass
	
	

