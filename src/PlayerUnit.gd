extends KinematicBody

signal health_changed
signal equipment_changed2

onready var model = $Rotator/Spacesuit

func _ready():
	var pistol = CreateEquipment.get_equipment(CreateEquipment.EquipType.Pistol)
	$CanCarry.items.push_back(pistol)
	$CanCarry.current_item = $CanCarry.get_first_gun()

	var grenade = CreateEquipment.get_equipment(CreateEquipment.EquipType.AP50)
	$CanCarry.items.push_back(grenade)

	var medikit = CreateEquipment.get_equipment(CreateEquipment.EquipType.MediKit)
	$CanCarry.items.push_back(medikit)

	var rocketlauncher = CreateEquipment.get_equipment(CreateEquipment.EquipType.RocketLauncher)
	$CanCarry.items.push_back(rocketlauncher)

	var rocket = CreateEquipment.get_equipment(CreateEquipment.EquipType.Rocket)
	$CanCarry.items.push_back(rocket)

	model.idle()
	
	call_deferred("emit_signal", "health_changed", self)
	call_deferred("emit_signal", "equipment_changed2")
	pass


func set_target(enemy:KinematicBody):
	$CanUseItem.current_target = enemy
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
	
	
func turn_to_face(point:Vector3):
	point.y = $Rotator.global_translation.y
	$Rotator.look_at(point, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func _on_PlayerUnit_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			EventBus.player_selected(self)
		pass
	pass
	

func idle_anim():
	$Rotator/Spacesuit.idle()
	pass
	
	
func walk_anim():
	$Rotator/Spacesuit.walk()
	pass
	
	
func shoot_anim():
	$Rotator/Spacesuit.shoot()
	pass


func _on_UnitData_shot(shooter:Spatial):
	if shooter != null:
		$Rotator.look_at(shooter.global_translation, Vector3.UP)
		$Rotator.rotation_degrees.y -= 90
	model.shot()
	model.get_node("BloodSplatter").activate()
	
	if $IsPlayer.selected == false:
		$CanUseItem.current_target = shooter # todo - check priority of current target against new one?

	emit_signal("health_changed", self)
	pass
	

func _on_UnitData_killed(shooter:Spatial):
	#_stop_walking()
	if shooter != null:
		$Rotator.look_at(shooter.global_translation, Vector3.UP)
		$Rotator.rotation_degrees.y -= 90
		pass
		
	model.killed()
	emit_signal("health_changed", self)
	
	$CanMove.has_destination = false
	$CanMove.route_polygon.visible = false
	pass


func emit_signal_equipment_changed():
	emit_signal("equipment_changed2")
	pass
	

func selected():
	get_node("SelectedArrow").visible = true
	get_node("IsPlayer").selected = true
	
	var can_move = get_node("CanMove")
	can_move.set_route_colour(Color.green)
	pass
	
	
func deselected():
	get_node("SelectedArrow").visible = false
	get_node("IsPlayer").selected = false
	var can_move = get_node("CanMove")
	can_move.set_route_colour(Color.gray)
	pass

