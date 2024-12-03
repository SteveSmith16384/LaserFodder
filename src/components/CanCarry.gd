extends Node

var items = []
var current_item

func get_first_gun():
	for item in items:
		if item.has_node("IsGun"):
			return item
			
	return null
	
