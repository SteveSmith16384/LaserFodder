extends RigidBody

var radius: float
var damage: float

func init(rad:float, dmg: float):
	radius = rad
	damage = dmg
	pass
	
	
func _on_ExplodeTimer_timeout():
	EventBus.explosion(self.global_translation, radius, damage)
	self.queue_free()
	pass
