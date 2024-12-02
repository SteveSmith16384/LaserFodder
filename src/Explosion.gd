extends Spatial

signal finished_changing_map

var audio_node : AudioStreamPlayer3D
var frame_count = 0

func _ready():
	audio_node = get_node("AudioStreamPlayer")
	if audio_node != null:
		audio_node.play()
	pass


func _physics_process(_delta):
	frame_count += 1
	if frame_count == 2:
		_check_for_hits()
		emit_signal("finished_changing_map")
	pass
	
	
func _on_Timer_timeout():
	queue_free()
	pass


func _check_for_hits():
	var nodes = $Area.get_overlapping_bodies()
	for node in nodes:
#		var cie = node.find_node("CaughtInExplosion")
#		if cie == null:
#			continue
#		cie.caught_in_explosion()
		if node.has_method("caught_in_explosion"):
			node.caught_in_explosion()
	pass
	
	
