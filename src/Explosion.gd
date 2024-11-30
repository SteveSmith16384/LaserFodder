extends Spatial

var audio_node : AudioStreamPlayer3D

func _ready():
	audio_node = get_node("AudioStreamPlayer")
	if audio_node != null:
		audio_node.play()
	pass
	
	
func _on_Timer_timeout():
	queue_free()
	pass
