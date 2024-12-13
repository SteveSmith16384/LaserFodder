extends Node

const VERSION = "1.0"
const RELEASE_MODE = false

const SHOW_FPS = true and !RELEASE_MODE
const SHOW_ASTAR_ROUTE = false and !RELEASE_MODE

const SIDE_PLAYER = 0
const SIDE_STERNER = 1

# These must match dropdown in player ui:-
const ACTION_STOP = 0
const ACTION_WALK_SHOOT = 1
const ACTION_RUN = 2

var astar: AStar
var rnd : RandomNumberGenerator
var game_paused = false
#var centre_on_unit = false


func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
	

func get_unit_name(idx:int) -> String:
	match idx:
		0: return "Corporal Jonlan"
		1: return "Styke Vomit"
		2: return "Leeder Krenon"
		3: return "Private Anderson"
		_: return "Private Stone"
	pass
	
	
#func face(us: Spatial, player:Spatial, delta:float):
#	var us_pos = self.translation
#	var them_pos = player.translation
#	var wtransform = us.global_transform.looking_at(Vector3(them_pos.x, us_pos.y ,them_pos.z),Vector3(0,1,0))
#	var wrotation = Quat(us.global_transform.basis).slerp(Quat(wtransform.basis), delta*5)
#	us.global_transform = Transform(Basis(wrotation), us.global_transform.origin)
#	pass
	
