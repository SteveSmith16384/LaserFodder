extends Node

var selected : bool = false
var unit_name: String

func _ready():
	self.get_parent().add_to_group("player")
	pass
	
