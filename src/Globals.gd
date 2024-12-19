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

enum GameStage {DEPLOYMENT, IN_GAME}
var game_stage : int = GameStage.DEPLOYMENT

enum EquipType { Pistol, Autogun, AP25, AP50, AP100, MediKit, RocketLauncher, Rocket, DroidLaser, LasPack }



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
	
	
