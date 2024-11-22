extends Node

var items = []

func get_first_gun():
	for item in items:
		if item.has_node("IsGun"):
			return item
			
	return null
	
