extends RigidBody

var applied = false


func _ready():
	#apply_central_impulse(Vector3(0, 120, 0))
	pass


func _physics_process(delta):
	if applied == false:
		#apply_central_impulse(Vector3(0, 120, 0))
		applied = true
	pass
	
