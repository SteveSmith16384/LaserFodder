extends KinematicBody

# These will shoot at any gang members or anyone who shoots at them (i.e police)

export(HasAI.Mode) var current_mode

const SPEED = 1.65

const pistol_class = preload("res://CarriedPistol.tscn")

signal selected

func _ready():
	var pistol = pistol_class.instance()
	$CanCarry.items.push_back(pistol)
	$CanShoot.current_weapon = $CanCarry.get_first_gun()
	$HasAI.current_mode = current_mode
	pass


func idle_anim():
	$Rotator/Punk.idle()
	return


func walk_anim():
	$Rotator/Punk.walk()
	return


func run_anim():
	$Rotator/Punk.run()
	return


func shoot_anim():
	$Rotator/Punk.shoot()
	return
	

func turn_to_face(enemy:Spatial):
	$Rotator.look_at(enemy.global_translation, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func can_see(enemy:Spatial) -> bool:
	return $CheckCanSeeRay.can_see(enemy)
	

func _on_CanBeShot_killed(_shooter:Spatial):
	$Rotator/Punk.killed()
	pass


func _on_CanBeShot_shot(shooter:Spatial):
	turn_to_face(shooter)
	$Rotator/Punk.shot()
	
	$Rotator/Punk/BloodSplatter.activate()
	pass


func _on_EnemyAgent_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			emit_signal("selected", self)
		pass
	pass


