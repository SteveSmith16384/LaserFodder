extends RigidBody

var radius: float
var damage: float

var time_until_explode :float = 5.0

func init(rad:float, dmg: float):
	radius = rad
	damage = dmg
	pass
	
	
func _physics_process(delta):
	if Globals.game_paused:
		return
	
	time_until_explode -= delta
	if time_until_explode <= 0:
		EventBus.explosion(self.global_translation, radius, damage)
		queue_free()
		return
		
