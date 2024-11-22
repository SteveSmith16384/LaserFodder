extends KinematicBody

const SPEED = 3#1.65

const pistol_class = preload("res://CarriedPistol.tscn")

signal selected
signal equipment_changed
signal stats_changed

onready var model = $Rotator/Swat
var has_destination = false
var destination: Vector3

func _ready():
	var pistol = pistol_class.instance()
	$CanCarry.items.push_back(pistol)
	$CanShoot.current_weapon = $CanCarry.get_first_gun()

	model.idle()
	
	call_deferred("emit_signal", "stats_changed", self)
	call_deferred("emit_signal", "equipment_changed", self)
	pass


func _physics_process(_delta):
	if $CanBeShot.killed:
		# We're dead
		return

	if $CanShoot.current_target != null:
		if is_instance_valid($CanShoot.current_target) == false:
			# Target is dead
			$CanShoot.current_target = null
			return

		var cbs = $CanShoot.current_target.get_node("CanBeShot")
		if cbs.killed:
			# Target is dead
			$CanShoot.current_target = null
			return
			
		var can_see = $CheckCanSeeRay.can_see($CanShoot.current_target)
		if can_see:
			turn_to_face($CanShoot.current_target)
			
			var dist = self.global_translation.distance_to($CanShoot.current_target.global_translation)
			var is_gun = $CanShoot.current_weapon.get_node("IsGun")
			if dist < is_gun.distance:
				has_destination = false
				var shot_fired = $CanShoot.shoot()
				if shot_fired:
					model.shoot_anim()
					emit_signal("equipment_changed", self)
				return
			else:
				# Walk towards them
				set_destination($CanShoot.current_target.translation, false)
		else:
			# Walk towards them
			set_destination($CanShoot.current_target.translation, false)
			pass
		
	if has_destination == false:
		return
	
	destination.y = self.translation.y

	var dir:Vector3 = destination - self.translation
	if dir.length() < 2: # Reached destination?
		_stop_walking()
		return
		
	var offset :Vector3 = dir.normalized() * SPEED
	var old_pos:= Vector2(translation.x, self.translation.z)
	self.move_and_slide(offset)
		
	# Rotate based on new position
	var new_pos:= Vector2(translation.x, self.translation.z)
	var ang:float = old_pos.angle_to_point(new_pos)
	$Rotator.rotation.y = -ang

	model.walk()
	pass
	

func set_target(enemy:KinematicBody):
	$CanShoot.current_target = enemy
	var can_see = $CheckCanSeeRay.can_see($CanShoot.current_target)
	if can_see == false:
		self.set_destination(enemy.global_translation, false)
	pass
	
	
func set_label(i:int):
	$Label3D.text = str(i)
	pass
	
	
func turn_to_face(enemy:Spatial):
	$Rotator.look_at(enemy.global_translation, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func _stop_walking():
	has_destination = false
	#emit_signal("reached_destination")
	model.idle()
	pass
	
	
func _on_PlayerUnit_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("selected", self)
		pass
	pass
	

func set_destination(pos: Vector3, clear_target:bool, rnd_offset = false):
	destination = pos
	
	if rnd_offset:
		destination.x += Globals.rnd.randi_range(-2, 2)
		destination.z += Globals.rnd.randi_range(-2, 2)

	has_destination = true
	
	if clear_target:
		$CanShoot.current_target = null # Otherwise they won't move until they've killed the target
	pass


func _on_CanBeShot_killed(shooter:Spatial):
	_stop_walking()
	$Rotator.look_at(shooter.global_translation, Vector3.UP)
	$Rotator.rotation_degrees.y -= 90
	model.killed()
	emit_signal("stats_changed", self)
	pass


func _on_CanBeShot_shot(shooter:Spatial):
	_stop_walking()
	$Rotator.look_at(shooter.global_translation, Vector3.UP)
	$Rotator.rotation_degrees.y -= 90
	model.shot()
	
	$Rotator/Swat/BloodSplatter.activate()
	
	$CanShoot.current_target = shooter # todo - check priority of current target against new one?
	emit_signal("stats_changed", self)
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

