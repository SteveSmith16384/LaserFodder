class_name Bullet 
extends KinematicBody

const SPEED = 20

var is_gun
var shooter

func _ready():
	if shooter == null:
		push_warning("No shooter!")
	pass


func init(gun_data):
	is_gun = gun_data
	pass
	
	
func _process(delta):
	var dir = global_transform.basis.z * delta * -1 * SPEED
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if col.collider != shooter:
			var cbs = col.collider.find_node("CanBeShot", false)
			if cbs != null:
				cbs.dec_health(shooter, is_gun.damage)
			else:
				#main.tiny_explosion(self)
				pass
			queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass
