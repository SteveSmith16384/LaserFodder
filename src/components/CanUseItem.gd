extends Spatial

const throwngrenade_class = preload("res://ThrownGrenade.tscn")

export var bullet_colour: Color = Color.white

var current_target : Spatial

func use_item(current_weapon, target_point: Vector3): # Return whether to play shoot anim
	var is_gun:IsGun = current_weapon.find_node("IsGun")
	if is_gun != null:
		get_parent().turn_to_face(target_point)
		if is_gun.get_ammo() <= 0:
			print("Out of ammo!")
			return false
		if is_gun.time_of_next_shot > Time.get_ticks_msec():
			return false
			
		is_gun.dec_ammo()
		is_gun.num_left_in_burst -= 1
		if is_gun.num_left_in_burst <= 0:
			is_gun.time_of_next_shot = Time.get_ticks_msec() + is_gun.reload_time_millis
			$Audio_Reload.play()
			is_gun.num_left_in_burst = is_gun.burst_size
		else:
			is_gun.time_of_next_shot = Time.get_ticks_msec() + Globals.rnd.randf_range(200, 300)
			
		if is_gun.shot_sfx != null:
			$Audio_Shoot.stream = is_gun.shot_sfx
			$Audio_Shoot.play()
		
		var unit_data:UnitData = get_parent().get_node("UnitData")
		var bullet:Spatial = is_gun.bullet_class.instance()
		bullet.init(get_parent(), unit_data.side, is_gun, bullet_colour)
		var origin = get_parent().get_node("Rotator/Muzzle").global_translation
		#bullet.translation = get_parent().get_node("Muzzle").global_translation
		target_point.y = origin.y
		bullet.look_at_from_position(origin, target_point, Vector3.UP)
		
		var acc: float = 100.0 * (is_gun.accuracy/100.0) * (unit_data.accuracy/100.0)
		var rnd:float = Globals.rnd.randf_range(0, 100)
		if rnd > acc:
			var diff = (rnd - acc) / 2.0
			bullet.rotation_degrees.y += Globals.rnd.randf_range(-diff, diff)
		self.get_parent().get_parent().add_child(bullet)
		
		return true
	
	# throw_grenade?
	var is_gren = current_weapon.find_node("IsGrenade")
	if is_gren != null:
		#get_parent().turn_to_face(target_point)
		var offset:Vector3 = target_point - get_parent().global_translation
		offset.y = 0
		#offset = offset.normalized()
		var force:Vector3 = offset * 1.4
		force = force.limit_length(20)
		force.y = 3

		var g:RigidBody = throwngrenade_class.instance()
		g.init(is_gren.radius, is_gren.damage)
		g.apply_central_impulse(force)
		g.translation = get_parent().global_translation + offset.normalized()
		g.translation.y = 1
		get_parent().get_parent().add_child(g)
		
#		emit_signal("equipment_changed2")
		var can_carry = get_parent().get_node("CanCarry")
		can_carry.use_up_current_item()
		return true

	var is_medi = current_weapon.find_node("IsMediKit")
	if is_medi != null:
		var unit_data = get_parent().get_node("UnitData")
		unit_data.reset_health()
	pass
	

