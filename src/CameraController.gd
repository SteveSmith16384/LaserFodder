extends Spatial

const SPEED:float = 15.0
const distance : float = 10.0

var _target_aim : Vector3
var current_aim: Vector3

var height : float = 16.0

var hidden_spatials = []

func _process(delta):
	if _target_aim == null:
		return
		
	current_aim = lerp(current_aim, _target_aim, 0.5)
	
	if Input.is_action_pressed("ui_left"):
		_target_aim.x -= delta * SPEED
		pass
	elif Input.is_action_pressed("ui_right"):
		_target_aim.x += delta * SPEED
		pass
		
	if Input.is_action_pressed("ui_up"):
		_target_aim.z -= delta * SPEED
	elif Input.is_action_pressed("ui_down"):
		_target_aim.z += delta * SPEED

	self.translation.x = current_aim.x# + x
	self.translation.y = height
	self.translation.z = current_aim.z+5# + z
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			#print("Left button was clicked at ", event.position)
			height += 0.5
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			#print("Wheel up")
			height -= 0.5
	pass


func set_target_aim(pos:Vector3):
	_target_aim = pos
	return
	
