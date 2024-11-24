extends Spatial

const SPEED:float = 15.0
const distance : float = 10.0

#var target_pos: Vector3
var target_aim : Vector3#Spatial
var current_aim: Vector3

#var angle: float
var height : float = 16.0

var hidden_spatials = []

func _process(delta):
	if target_aim == null:
		return
		
	current_aim = lerp(current_aim, target_aim, 0.5)
	
	if Input.is_action_pressed("ui_left"):
		target_aim.x -= delta * SPEED
		#self.translation.x += delta * SPEED
		#angle -= delta * SPEED
		pass
	elif Input.is_action_pressed("ui_right"):
		target_aim.x += delta * SPEED
		#self.translation.x -= delta * SPEED
		#angle += delta * SPEED
		pass
		
	if Input.is_action_pressed("ui_up"):
		target_aim.z -= delta * SPEED
#		distance -= delta * SPEED
#		#self.translation.z += delta * SPEED
	elif Input.is_action_pressed("ui_down"):
		target_aim.z += delta * SPEED
#		#self.translation.z -= delta * SPEED
#		distance += delta * SPEED
	
#	if angle < 0:
#		angle += PI*2
#	elif angle > PI*2:
#		angle -= PI*2
	#print("Angle=" + str(angle))
	
#	var x = cos(angle) * distance
#	var z = sin(angle) * distance
	self.translation.x = current_aim.x# + x
	self.translation.y = height
	self.translation.z = current_aim.z+5# + z
	
#	$Camera.look_at(current_aim, Vector3.UP)
	
#	var dir:Vector3 = self.global_translation - current_aim
#	$RayCast.cast_to = dir
	pass


func _physics_process(_delta):
#	var new_hidden = []
#	var coll = $RayCast.get_collider()
#	if coll != null:
#		# Should only be a building
#		coll.visible = false
#		new_hidden.push_back(coll)
#
#	for sp in hidden_spatials:
#		if new_hidden.has(sp) == false:
#			sp.visible = true
#
#	hidden_spatials = new_hidden
	pass
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			#print("Left button was clicked at ", event.position)
			height -= 0.5
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			#print("Wheel up")
			height += 0.5
	pass

