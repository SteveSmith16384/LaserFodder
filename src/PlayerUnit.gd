extends KinematicBody

const pistol_class = preload("res://CarriedPistol.tscn")

#signal stats_changed

onready var model = $Rotator/Spacesuit
#var has_destination = false
#var destination: Vector3

func _ready():
	var pistol = pistol_class.instance()
	$CanCarry.items.push_back(pistol)
	$CanShoot.current_weapon = $CanCarry.get_first_gun()

	model.idle()
	
	#call_deferred("emit_signal", "stats_changed", self)
	#call_deferred("emit_signal", "equipment_changed", self)
	pass


func _physics_process(_delta):
	pass
	

func set_target(enemy:KinematicBody):
	$CanShoot.current_target = enemy
#	var can_see = $CheckCanSeeRay.can_see($CanShoot.current_target)
#	if can_see == false:
#		self.set_destination(enemy.global_translation, false)
	pass
	

func can_see_target(target:Spatial):
	var can_see = $CheckCanSeeRay.can_see_target(target)
	return can_see
	
		
func can_see_point(point:Vector3) -> bool:
	var can_see = $CheckCanSeeRay.can_see_point(point - self.translation)
	return can_see == null
	
		
func set_label(i:int):
	$Label3D.text = str(i)
	pass
	
	
func turn_to_face(enemy:Spatial):
	$Rotator.look_at(enemy.global_translation, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func _on_PlayerUnit_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			EventBus.player_selected(self)
			#emit_signal("selected", self)
		pass
	pass
	

func _on_CanBeShot_killed(shooter:Spatial):
	#_stop_walking()
	$Rotator.look_at(shooter.global_translation, Vector3.UP)
	$Rotator.rotation_degrees.y -= 90
	model.killed()
	#todo emit_signal("stats_changed", self)
	pass


func _on_CanBeShot_shot(shooter:Spatial):
	#_stop_walking()
	$Rotator.look_at(shooter.global_translation, Vector3.UP)
	$Rotator.rotation_degrees.y -= 90
	model.shot()
	
	model.get_node("BloodSplatter").activate()
	
	$CanShoot.current_target = shooter # todo - check priority of current target against new one?
	#todo emit_signal("stats_changed", self)
	pass


#func _on_CheckForEnemyTimer_timeout():
#	if $CanShoot.current_target == null:
#		_check_for_enemy()
#	pass
#
#
#func _check_for_enemy():
#	var closest: KinematicBody = null
#	var closest_dist: float = 9999
#
#	var enemy_units = has_ai.get_potential_enemies()
#	for enemy_unit in enemy_units:
#		var can_see:bool = entity.can_see(enemy_unit)
#		if can_see:
#			var cbs = enemy_unit.get_node("CanBeShot")
#			if cbs.killed:
#				continue
#			# check distance
#			var dist = entity.global_translation.distance_to(enemy_unit.global_translation)
#			if dist > Globals.AI_VIEW_DISTANCE:
#				continue
#			if dist < closest_dist:
#				closest_dist = dist
#				closest = enemy_unit
#
#	can_shoot.current_target = closest
#	pass


func idle_anim():
	$Rotator/Spacesuit.idle()
	pass
	
	
func walk_anim():
	$Rotator/Spacesuit.walk()
	pass
	
	
func shoot_anim():
	$Rotator/Spacesuit.shoot()
	pass
	
