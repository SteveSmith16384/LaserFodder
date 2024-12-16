class_name CanCarry
extends Node

var items = []
var current_item

func get_first_gun():
	for item in items:
		if item.has_node("IsGun"):
			return item
			
	return null
	

func use_up_current_item():
	items.erase(current_item)
	if items.size() > 0:
		current_item = items[0]
	else:
		current_item = null
	pass
	
