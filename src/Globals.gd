extends Node

const VERSION = "1.0"
const RELEASE_MODE = false

const AI_VIEW_DISTANCE = 40.0

const SHOW_FPS = false and !RELEASE_MODE

# Other settings
const NUM_CIVS = 10
const NUM_POLICE = 2
const NUM_ENEMY = 4

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
	

func face(us: Spatial, player:Spatial, delta:float):
	var us_pos = self.translation
	var them_pos = player.translation
	var wtransform = us.global_transform.looking_at(Vector3(them_pos.x, us_pos.y ,them_pos.z),Vector3(0,1,0))
	var wrotation = Quat(us.global_transform.basis).slerp(Quat(wtransform.basis), delta*5)
	us.global_transform = Transform(Basis(wrotation), us.global_transform.origin)
	pass
	
