class_name FiredRocket
extends KinematicBody

const SPEED = 15.0

var is_gun
var shooter:Spatial
var time_until_explode :float = 5.0

func _ready():
	if shooter == null:
		push_warning("No shooter!")
	pass


func init(_shooter, _side, gun_data, _col:Color):
	is_gun = gun_data
	pass
	
	
func _physics_process(delta):
	if Globals.game_paused:
		return
	
	time_until_explode -= delta
	if time_until_explode <= 0:
		queue_free()
		return
		
	var dir = global_transform.basis.z * delta * -1 * SPEED
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if col.collider != shooter:
			EventBus.explosion(self.global_translation, 7, 75)
			queue_free()
	pass

