extends KinematicBody

const laser_class = preload("res://CarriedDroidLaser.tscn")
const bullet_class = preload("res://Bullet.tscn")
const droid_corpse_class = preload("res://DestroyedRobot.tscn")


func _ready():
	var laser = laser_class.instance()
	$CanCarry.items.push_back(laser)
	$CanCarry.current_item = laser#$CanCarry.get_first_gun()
	
	self.visible = false
	pass
	
	
func turn_to_face(point:Vector3):
	$Rotator.look_at(point, Vector3.UP)
	$Rotator.rotation.y -= PI/2
	pass
	

func can_see_target(enemy:Spatial) -> bool:
	return $CheckCanSeeRay.can_see_target(enemy)
	

func can_see_point(point:Vector3) -> bool:
	var can_see = $CheckCanSeeRay.can_see_point(point - self.translation)
	return can_see == null
	
		
func _on_EnemyDroid_input_event(_camera, _event, _position, _normal, _shape_idx):
#	if event is InputEventMouseButton:
#		if event.button_index == 2 and event.pressed:
			#EventBus.enemy_selected(self)
			#emit_signal("selected", self)
#		pass
	pass


func _on_UnitData_shot(_shooter):
	$Rotator/MakeCentre/NewModel/Sparks.activate()
	pass


func _on_UnitData_killed(_shooter):
	var corpse: Spatial = droid_corpse_class.instance()
	corpse.translation = self.translation
	get_parent().add_child(corpse)
	
	self.queue_free()
	pass
