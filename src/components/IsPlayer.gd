extends Node

var selected : bool = false

func _ready():
	self.get_parent().add_to_group("player")
	pass
	
