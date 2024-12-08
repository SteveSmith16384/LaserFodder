class_name Bullet 
extends KinematicBody

const SPEED = 20.0

const sparks_class = preload("res://Sparks.tscn")

var is_gun
var shooter:Spatial
var side: int

func _ready():
	if shooter == null:
		push_warning("No shooter!")
	pass


func init(shooter_, side_, gun_data, col:Color):
	if shooter_ == null:
		push_warning("No shooter!")
		
	shooter = shooter_
	side = side_
	is_gun = gun_data
	$MeshInstance.get_surface_material(0).albedo_color = col
	pass
	
	
func _physics_process(delta):
	if Globals.game_paused:
		return
		
	var dir = global_transform.basis.z * delta * -1 * SPEED
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if col.collider != shooter:
			var ud :UnitData= col.collider.find_node("UnitData", false)
			if ud != null:
				if ud.side != side:
					ud.dec_health(shooter, is_gun.damage)
			else:
				if is_instance_valid(self.shooter):
					var sparks:Spatial = sparks_class.instance()
					sparks.look_at_from_position(self.translation, self.shooter.translation, Vector3.UP)
					self.get_parent().add_child(sparks)
					sparks.activate()
				pass
			queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass
