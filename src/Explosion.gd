extends Spatial

var audio_node : AudioStreamPlayer3D
var frame_count = 0

func _ready():
	audio_node = get_node("AudioStreamPlayer")
	if audio_node != null:
		audio_node.play()
	pass


func _physics_process(delta):
	frame_count += 1
	if frame_count == 2:
		_check_for_hits()
	pass
	
	
func _on_Timer_timeout():
	queue_free()
	pass


func _check_for_hits():
	var nodes = $Area.get_overlapping_bodies()
	pass
	
	
