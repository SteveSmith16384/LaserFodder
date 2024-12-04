extends Node

const SPEED = 2
const ENEMY_TARGET_CHECK_INTERVAL :float = 0.8

func _process(delta):
	var sterners = get_tree().get_nodes_in_group("sterner")
	for sterner in sterners:
		_process_entity(delta, sterner)
	pass
	

func _process_entity(_delta: float, sterner:KinematicBody):
	#return # todo
	var unit_data = sterner.get_node("UnitData")
	if unit_data.killed:
		# We're dead!
		return
	
	var can_move = sterner.get_node("CanMove")
	var can_shoot = sterner.get_node("CanUseItem")
	
	if can_shoot.current_target != null:
		if is_instance_valid(can_shoot.current_target) == false:
			# Target destroyed
			can_shoot.current_target = null
			return
			
		var ud = can_shoot.current_target.get_node("UnitData")
		if ud.killed:
			# Target destroyed
			can_shoot.current_target = null
			return
		
		var can_see:bool = sterner.can_see_target(can_shoot.current_target)
		if can_see == false:
			# Why?
			can_see = sterner.can_see_target(can_shoot.current_target) # todo - remove
			
			#can_move.destination = can_shoot.current_target.translation
			CanMove.set_destination(sterner, can_move, can_shoot.current_target.translation)
			can_shoot.current_target = null
			return
		
		can_move.has_destination = false
		
		# face target
		#droid.turn_to_face(can_shoot.current_target)

		#var dist = entity.global_translation.distance_to(can_shoot.current_target.global_translation)
		#var is_gun = can_shoot.current_weapon#.get_node("IsGun")
		#if dist < is_gun.distance:
		var can_carry = sterner.get_node("CanCarry")
		if can_carry.current_item != null:
			var shot_fired = can_shoot.use_item(can_carry.current_item, can_shoot.current_target.global_translation)
			if shot_fired:
				sterner.shoot_anim()
			#return
#		else:
#			can_move.destination = can_shoot.current_target.translation
	else:
		if can_shoot.time_until_target_check <= 0:
			_check_for_enemy(sterner, can_shoot)
			can_shoot.time_until_target_check = ENEMY_TARGET_CHECK_INTERVAL
			pass
	pass
	
	if can_move.has_destination == false:
		# todo - wander?
	#	if can_move.current_mode == CanMove.Mode.WALK:
		return
	
	var next_dest: Vector3 = can_move.route_points[can_move.route_index]
	
	if can_move.route_index + 1 < can_move.route_points.size():
		# Can we see ahead?
		if sterner.can_see_point(can_move.route_points[can_move.route_index+1]):
			can_move.route_index += 1
			next_dest = can_move.route_points[can_move.route_index]
			
	next_dest.y = sterner.translation.y

	var dir:Vector3 = next_dest - sterner.translation
	if dir.length() < .2: # Reached point
		can_move.route_index += 1
		if can_move.route_index >= can_move.route_points.size():
			 # Reached destination
			can_move.has_destination = false
		return # Loop around next time
		
	var offset :Vector3 = dir.normalized() * SPEED
	var old_pos:= Vector2(sterner.translation.x, sterner.translation.z)
	sterner.move_and_slide(offset)
		
	# Rotate based on new position
	var new_pos:= Vector2(sterner.translation.x, sterner.translation.z)
	var ang:float = old_pos.angle_to_point(new_pos)
	sterner.get_node("Rotator").rotation.y = -ang
	pass


func _check_for_enemy(entity, can_shoot):
	var closest: KinematicBody = null
	var closest_dist: float = 9999
	
	var enemy_units = get_tree().get_nodes_in_group("player")
	for enemy_unit in enemy_units:
		var can_see:bool = entity.can_see_target(enemy_unit)
		if can_see:
			var ud = enemy_unit.get_node("UnitData")
			if ud.killed:
				continue
			# check distance
			var dist = entity.global_translation.distance_to(enemy_unit.global_translation)
			#if dist > Globals.AI_VIEW_DISTANCE:
			#	continue
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy_unit
				
	can_shoot.current_target = closest
	pass

