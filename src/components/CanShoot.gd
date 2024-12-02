extends Spatial

var current_target : Spatial
var current_weapon # IsGun
var weapon_drawn = false

var time_until_next_shot:float = 0
var time_until_target_check: float
var num_left_in_burst: int = 3

func _process(delta:float):
	time_until_next_shot -= delta
	time_until_target_check -= delta
	pass
	

func shoot(target_point: Vector3): # Return whether to play shoot anim
	get_parent().turn_to_face(target_point)
	
	var is_gun = current_weapon.get_node("IsGun")
	if is_gun.get_ammo() <= 0:
		print("Out of ammo!")
		return false
	if time_until_next_shot > 0:
		return false
		
	is_gun.dec_ammo()
	num_left_in_burst -= 1
	if num_left_in_burst <= 0:
		time_until_next_shot = is_gun.reload_time
		$Audio_Reload.play()
		num_left_in_burst = Globals.rnd.randi_range(3, 5)
	else:
		time_until_next_shot = Globals.rnd.randf_range(0.2, 0.3)
		
	if is_gun.shot_sfx != null:
		$Audio_Shoot.stream = is_gun.shot_sfx
		$Audio_Shoot.play()
	
	var bullet:Spatial = is_gun.bullet_class.instance()# bullet_class.instance()
	bullet.init(is_gun)
	bullet.shooter = get_parent()
	var origin = get_parent().get_node("Rotator/Muzzle").global_translation
	#bullet.translation = get_parent().get_node("Muzzle").global_translation
	target_point.y = origin.y
	bullet.look_at_from_position(origin, target_point, Vector3.UP)
	self.get_parent().get_parent().add_child(bullet)
	
#	var tot_acc = accuracy * (is_gun.accuracy/100.0)
#	var r = Globals.rnd.randi_range(1, 100)
#	if r < tot_acc:
#		var cbs = current_target.get_node("CanBeShot")
#		cbs.dec_health(self.get_parent(), is_gun.damage)
#	else:
#		#print("Missed!")
#		pass
	return true
	
