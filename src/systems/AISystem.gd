extends Node

const ENEMY_TARGET_CHECK_INTERVAL :int = 1

func _process(delta):
	var entities = get_tree().get_nodes_in_group("has_ai")
	for entity in entities:
		_process_entity(delta, entity)
	pass
	

func _process_entity(delta: float, entity:KinematicBody):
	var our_cbs = entity.get_node("CanBeShot")
	if our_cbs.killed:
		# We're dead!
		return
	
	var has_ai = entity.get_node("HasAI")
	if has_ai.only_move_when_in_view and has_ai.is_in_view == false:
		return
		
	var can_shoot = entity.find_node("CanShoot", false)
	if can_shoot != null:
		has_ai.running = false#can_shoot.current_target != null
		if can_shoot.current_target != null:
			var cbs = can_shoot.current_target.get_node("CanBeShot")
			if cbs.killed:
				can_shoot.current_target = null
				return
			
			var can_see:bool = entity.can_see(can_shoot.current_target)
			if can_see == false:
				can_shoot.current_target = null
				return
				
			# face target
			entity.turn_to_face(can_shoot.current_target)

			var dist = entity.global_translation.distance_to(can_shoot.current_target.global_translation)
			var is_gun = can_shoot.current_weapon.get_node("IsGun")
			if dist < is_gun.distance:
				var shot_fired = can_shoot.shoot()#can_shoot.current_weapon, can_shoot.current_target)
				if shot_fired:
					entity.shoot_anim()
				else:
					#entity.idle_anim() No!  it plays straight away!
					pass
				return
			else:
				has_ai.running = true
		else:
			if can_shoot.time_until_target_check <= 0:
				_check_for_enemy(entity, has_ai, can_shoot)
				can_shoot.time_until_target_check = ENEMY_TARGET_CHECK_INTERVAL
				pass
		pass
	
	if has_ai.current_mode == HasAI.Mode.WALK:
		has_ai.time_until_change_dir -= delta
		if has_ai.time_until_change_dir <= 0:
			has_ai.time_until_change_dir = Globals.rnd.randf_range(4, 20)
			has_ai.walk_angle = Globals.rnd.randf_range(0, PI*2)
			pass
			
		var x = cos(has_ai.walk_angle) * entity.SPEED
		var z = sin(has_ai.walk_angle) * entity.SPEED
		var offset := Vector3(x, 0, z)
		if has_ai.running:
			offset = offset * 2
			
		var old_pos:= Vector2(entity.translation.x, entity.translation.z)
		entity.move_and_slide(offset)

		if has_ai.running:
			entity.run_anim()
		else:
			entity.walk_anim()
			
		# Rotate based on new position
		var new_pos:= Vector2(entity.translation.x, entity.translation.z)
		var ang:float = old_pos.angle_to_point(new_pos)
		entity.get_node("Rotator").rotation.y = -ang
	pass
	

func _check_for_enemy(entity, has_ai, can_shoot):
	if can_shoot.current_target != null:
		if is_instance_valid(can_shoot.current_target) == false:
			can_shoot.current_target = null
		return
	
	var closest: KinematicBody = null
	var closest_dist: float = 9999
	
	var enemy_units = has_ai.get_potential_enemies()
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

