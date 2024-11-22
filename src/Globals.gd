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
	
	# todo - delete this
#	var vecs := Vector2(0, 0)
#	var vece := Vector2(-10, 0)
#	var diff: Vector2 = vece - vecs
#	var ang = diff.angle()
	
#	var ang2 = vecs.angle_to_point(vece)
	pass
	

