extends Spatial

#var pos_x = 0
var opening = false
var closing = true
var closed = false
var num_bodies = 0

func _ready():
	pass


func _process(delta):
	if opening:
		closed = false
		$RightDoor.translation.x += delta
		if $RightDoor.translation.x > 1:
			$RightDoor.translation.x = 1
			opening = false
			#$CloseTimer.start()
	elif closing:
		$RightDoor.translation.x -= delta
		if $RightDoor.translation.x < 0:
			$RightDoor.translation.x = 0
			closing = false
			closed = true
			
	$LeftDoor.translation.x = -$RightDoor.translation.x
	pass


func _on_Area_body_entered(body):
	if opening:
		return
		
	if _does_body_activate_door(body):
		num_bodies += 1
		opening = true
		closing = false
		#$CloseTimer.stop()
		#$CloseTimer.start()
		$Audio_OpenClose.play()
	pass


func _on_CloseTimer_timeout():
	if closed:
		return
	if num_bodies <= 0:
		closing = true
		$Audio_OpenClose.play()
	pass


func _on_Area_body_exited(body):
	if _does_body_activate_door(body):
		num_bodies -= 1
	pass


func _does_body_activate_door(body):
	if body.is_in_group("droid"):
		return true
	if body.is_in_group("sterner"):
		return true
	if body.is_in_group("player"):
		return true
	
	return false
