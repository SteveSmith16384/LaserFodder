extends Spatial

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
		if closed:
			var cm = body.find_node("CanMove", false)
			if cm != null:
				cm.pause_for = 0.8
			
		num_bodies += 1
		opening = true
		closing = false
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
	# We use layer mask to determine if they affect the door
	if _does_body_activate_door(body):
		num_bodies -= 1
	pass


func _does_body_activate_door(body:Spatial):
	#var layer = body.get_collision_layer()
	
	if body.is_in_group("droid"):
		return true
	if body.is_in_group("player"):
		return true
	if body.is_in_group("sterner"):
		return true

	return false
