extends KinematicBody

const SPEED = 1.65

const pistol_class = preload("res://CarriedPistol.tscn")

onready var model:Spatial = $Rotator/Swat

func _ready():
	var pistol = pistol_class.instance()
	$CanCarry.items.push_back(pistol)
	$CanCarry.current_item = $CanCarry.get_first_gun()
	
	self.visible = false
	pass


func idle_anim():
	$model.idle()
	return


func walk_anim():
	model.walk()
	return


func run_anim():
	model.run()
	return


func shoot_anim():
	model.shoot()
	return
	

func turn_to_face(point:Vector3):
	$Rotator.look_at(point, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func can_see(enemy:Spatial) -> bool:
	return $CheckCanSeeRay.can_see(enemy)
	

func _on_EnemyAgent_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			emit_signal("selected", self)
		pass
	pass


func _on_UnitData_shot(shooter:Spatial):
	turn_to_face(shooter.global_translation)
	model.shot()
	
	model.get_node("BloodSplatter").activate()
	pass


func _on_UnitData_killed(_shooter:Spatial):
	model.killed()
	pass
