extends KinematicBody

const pistol_class = preload("res://CarriedPistol.tscn")
const grenade_class = preload("res://Grenade.tscn")

onready var model = $Rotator/Spacesuit

func _ready():
	var pistol = pistol_class.instance()
	$CanCarry.items.push_back(pistol)
	$CanShoot.current_weapon = $CanCarry.get_first_gun()

	model.idle()
	pass


func _physics_process(_delta):
	pass
	

func set_target(enemy:KinematicBody): # todo - inline
	$CanShoot.current_target = enemy
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
	
	if $IsPlayer.selected == false:
		$CanShoot.current_target = shooter # todo - check priority of current target against new one?
	pass


func throw_grenade(dest:Vector3):
	var g:RigidBody = grenade_class.instance()
	g.apply_central_impulse(Vector3(0, 12, 0))
	g.translation = self.translation
	g.translation.x += 2
	self.get_parent().add_child(g)
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
	
