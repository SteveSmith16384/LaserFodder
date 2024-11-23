extends Spatial

export var accuracy : float = 90

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
	

func shoot(): # Return whether to play shoot anim
	var gun = current_weapon#.get_node("IsGun")
	if gun.get_ammo() <= 0:
		print("Out of ammo!")
		return false
	if time_until_next_shot > 0:# < gun.reload_time:
		return false
		
	gun.dec_ammo()
	num_left_in_burst -= 1
	if num_left_in_burst <= 0:
		time_until_next_shot = gun.reload_time
		$Audio_Reload.play()
		num_left_in_burst = Globals.rnd.randi_range(3, 5)
	else:
		time_until_next_shot = Globals.rnd.randf_range(0.2, 0.3)
	$Audio_Shoot.stream = gun.shot_sfx
	$Audio_Shoot.play()
	
	var tot_acc = accuracy * (gun.accuracy/100.0)
	var r = Globals.rnd.randi_range(1, 100)
	if r < tot_acc:
		var cbs = current_target.get_node("CanBeShot")
		cbs.dec_health(self.get_parent(), gun.damage)
	else:
		print("Missed!")
	return true
	
