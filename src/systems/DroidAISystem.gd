extends Node

const ENEMY_TARGET_CHECK_INTERVAL :int = 1

func _process(delta):
	var entities = get_tree().get_nodes_in_group("droid")
	for entity in entities:
		_process_entity(delta, entity)
	pass
	

func _process_entity(_delta: float, entity:KinematicBody):
	return # todo
	
	var our_cbs = entity.get_node("CanBeShot")
	if our_cbs.killed:
		# We're dead!
		return
	
	var can_move = entity.get_node("CanMove")
	var can_shoot = entity.get_node("CanShoot")
	if can_shoot.current_target != null:
		var cbs = can_shoot.current_target.get_node("CanBeShot")
		if cbs.killed:
			can_shoot.current_target = null
			return
		
		var can_see:bool = entity.can_see(can_shoot.current_target)
		if can_see == false:
			can_move.destination = can_shoot.current_target.translation
			can_shoot.current_target = null
			return
			
		# face target
		entity.turn_to_face(can_shoot.current_target)

		var dist = entity.global_translation.distance_to(can_shoot.current_target.global_translation)
		var is_gun = can_shoot.current_weapon#.get_node("IsGun")
		if dist < is_gun.distance:
			var shot_fired = can_shoot.shoot()
			if shot_fired:
			#	entity.shoot_anim()
				return
		else:
			can_move.destination = can_shoot.current_target.translation
	else:
		if can_shoot.time_until_target_check <= 0:
			_check_for_enemy(entity, can_shoot)
			can_shoot.time_until_target_check = ENEMY_TARGET_CHECK_INTERVAL
			pass
	pass
	
	if can_move.current_mode == CanMove.Mode.WALK:
		var x = cos(can_move.walk_angle) * can_move.speed
		var z = sin(can_move.walk_angle) * can_move.speed
		var offset := Vector3(x, 0, z)
			
		var old_pos:= Vector2(entity.translation.x, entity.translation.z)
		entity.move_and_slide(offset)
		#entity.walk_anim()
			
		# Rotate based on new position
		var new_pos:= Vector2(entity.translation.x, entity.translation.z)
		var ang:float = old_pos.angle_to_point(new_pos)
		entity.get_node("Rotator").rotation.y = -ang
	pass
	

func _check_for_enemy(entity, can_shoot):
	if can_shoot.current_target != null:
		if is_instance_valid(can_shoot.current_target) == false:
			can_shoot.current_target = null
		return
	
	var closest: KinematicBody = null
	var closest_dist: float = 9999
	
	var enemy_units = get_tree().get_nodes_in_group("player")
	for enemy_unit in enemy_units:
		var can_see:bool = entity.can_see(enemy_unit)
		if can_see:
			var cbs = enemy_unit.get_node("CanBeShot")
			if cbs.killed:
				continue
			# check distance
			var dist = entity.global_translation.distance_to(enemy_unit.global_translation)
			if dist > Globals.AI_VIEW_DISTANCE:
				continue
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy_unit
				
	can_shoot.current_target = closest
	pass

