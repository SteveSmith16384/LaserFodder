class_name Bullet 
extends KinematicBody

const SPEED = 20.0

const sparks_class = preload("res://Sparks.tscn")

var is_gun
var shooter:Spatial

func _ready():
	if shooter == null:
		push_warning("No shooter!")
	pass


func init(gun_data, col:Color):
	is_gun = gun_data
	$MeshInstance.get_surface_material(0).albedo_color = col
	pass
	
	
func _physics_process(delta):
	var dir = global_transform.basis.z * delta * -1 * SPEED
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if col.collider != shooter:
			var ud = col.collider.find_node("UnitData", false)
			if ud != null:
				ud.dec_health(shooter, is_gun.damage)
			else:
				var sparks:Spatial = sparks_class.instance()
				#sparks.translation = self.translation
				sparks.look_at_from_position(self.translation, self.shooter.translation, Vector3.UP)
				self.get_parent().add_child(sparks)
				sparks.activate()
				pass
			queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass
