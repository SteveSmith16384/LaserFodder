class_name Bullet 
extends KinematicBody

const SPEED = 20

#var main #: Main
#var dir : Vector3
var is_gun
var shooter

func _ready():
	#main = get_tree().get_root().get_node("Main")
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
				cbs.dec_health(col.collider, is_gun.damage)
				#col.collider.hit_by_bullet()
				#main.small_explosion(col.collider)
				#self.queue_free()
			else:
				#main.play_clang()
				#main.tiny_explosion(self)
				pass
			queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass
