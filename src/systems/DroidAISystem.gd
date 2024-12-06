extends Node

const SPEED = 2
const ENEMY_TARGET_CHECK_INTERVAL :float = 1.0

func _process(delta):
	var droids = get_tree().get_nodes_in_group("droid")
	for droid in droids:
		_process_entity(delta, droid)
	pass
	

func _process_entity(delta: float, droid:KinematicBody):
	var unit_data = droid.get_node("UnitData")
	if unit_data.killed:
		# We're dead!
		return
	
	var can_move = droid.get_node("CanMove")
	var can_shoot = droid.get_node("CanUseItem")
	
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
		
		var can_see:bool = droid.can_see_target(can_shoot.current_target)
		if can_see == false:
			# Why?
			can_see = droid.can_see_target(can_shoot.current_target) # todo - remove
			
			#can_move.destination = can_shoot.current_target.translation
			CanMove.set_destination(droid, can_move, can_shoot.current_target.translation)
			can_shoot.current_target = null
			return
		
		can_move.has_destination = false
		
		# face target
		#droid.turn_to_face(can_shoot.current_target)

		#var dist = entity.global_translation.distance_to(can_shoot.current_target.global_translation)
		#var is_gun = can_shoot.current_weapon#.get_node("IsGun")
		#if dist < is_gun.distance:
		var can_carry = droid.get_node("CanCarry")
		var _shot_fired = can_shoot.use_item(can_carry.current_item, can_shoot.current_target.global_translation)
		#if shot_fired:
			#entity.shoot_anim()
			#return
#		else:
#			can_move.destination = can_shoot.current_target.translation
	else:
		unit_data.time_until_target_check -= delta
		if unit_data.time_until_target_check <= 0:
			_check_for_enemy(droid, can_shoot)
			unit_data.time_until_target_check = ENEMY_TARGET_CHECK_INTERVAL
			pass
	pass
	
	if can_move.has_destination == false:
		# todo - wander?
	#	if can_move.current_mode == CanMove.Mode.WALK:
		return
	
	var next_dest: Vector3 = can_move.route_points[can_move.route_index]
	
	if can_move.route_index + 1 < can_move.route_points.size():
		# Can we see ahead?
		if droid.can_see_point(can_move.route_points[can_move.route_index+1]):
			can_move.route_index += 1
			next_dest = can_move.route_points[can_move.route_index]
			
	next_dest.y = droid.translation.y

	var dir:Vector3 = next_dest - droid.translation
	if dir.length() < .2: # Reached point
		can_move.route_index += 1
		if can_move.route_index >= can_move.route_points.size():
			 # Reached destination
			can_move.has_destination = false
		return # Loop around next time
		
	var offset :Vector3 = dir.normalized() * SPEED
	var old_pos:= Vector2(droid.translation.x, droid.translation.z)
	droid.move_and_slide(offset)
		
	# Rotate based on new position
	var new_pos:= Vector2(droid.translation.x, droid.translation.z)
	var ang:float = old_pos.angle_to_point(new_pos)
	droid.get_node("Rotator").rotation.y = -ang
	pass


func _check_for_enemy(entity, can_shoot):
	entity.visible = false # Only show us if we can see an enemy
	
	var closest: KinematicBody = null
	var closest_dist: float = 9999
	
	var enemy_units = get_tree().get_nodes_in_group("player")
	for enemy_unit in enemy_units:
		var can_see:bool = entity.can_see_target(enemy_unit)
		if can_see:
			var ud = enemy_unit.get_node("UnitData")
			if ud.killed:
				continue
			entity.visible = true
			# check distance
			var dist = entity.global_translation.distance_to(enemy_unit.global_translation)
			#if dist > Globals.AI_VIEW_DISTANCE:
			#	continue
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy_unit
				
	can_shoot.current_target = closest
	pass

