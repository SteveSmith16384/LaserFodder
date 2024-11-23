extends KinematicBody

#var pistol_class = preload()
var bullet_class = preload("res://Bullet.tscn")
var droid_corpse_class = preload("res://DestroyedRobot.tscn")


func _ready():
	$CanShoot.current_weapon = $CanShoot/IsGun
#	var pistol = pistol_class.instance()
#	$CanCarry.items.push_back(pistol)
#	$CanShoot.current_weapon = $CanCarry.get_first_gun()
	pass
	
	
func _physics_process(_delta):

#	if player_in_area == false or can_see_player == false:
#		if patrol_points == null:
#			patrol_points = main.get_patrol_points(self);
#			patrol_index = 0
#			# SHow debugging nodes
#			main.get_node("SternersHouse/FinalDest").translation = patrol_points[patrol_points.size()-1]
#			main.get_node("SternersHouse/FinalDest").translation.y = 0.5
#			
#		var target = patrol_points[patrol_index]
#		target.y = 0

#		if translation.distance_to(target) < 1:
#			patrol_index = patrol_index + 1
#			if patrol_index >= patrol_points.size():
#				patrol_points = null
#				#print("End of route")
#				return
	pass


func turn_to_face(enemy:Spatial):
	$Rotator.look_at(enemy.global_translation, Vector3.UP)
	#$Rotator.rotation.y -= PI/2
	pass
	

func can_see(enemy:Spatial) -> bool:
	return $CheckCanSeeRay.can_see(enemy)
	


