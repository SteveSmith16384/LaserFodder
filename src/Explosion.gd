extends Spatial

signal finished_changing_map

var audio_node : AudioStreamPlayer3D
var frame_count = 0
var radius: float
var damage: float

func init(rad:float, dmg: float):
	radius = rad
	damage = dmg
	
	var sphere: SphereShape = $Area/CollisionShape.shape
	sphere.radius = radius
	pass
	
	
func _ready():
	$CPUParticles.emitting = true
	
	audio_node = get_node("AudioStreamPlayer")
	if audio_node != null:
		audio_node.play()
	pass


func _physics_process(_delta):
	frame_count += 1
	if frame_count == 3:
		_check_for_hits()
		emit_signal("finished_changing_map")
	pass
	
	
func _on_Timer_timeout():
	queue_free()
	pass


func _check_for_hits():
	var nodes = $Area.get_overlapping_bodies()
	for node in nodes:
		if node.has_method("caught_in_explosion"):
			node.caught_in_explosion()
		var unit_data:UnitData = node.find_node("UnitData")
		if unit_data != null:
			unit_data.dec_health(null, self.damage)
	pass
	
	
