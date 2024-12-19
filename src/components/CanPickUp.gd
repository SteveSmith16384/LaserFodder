extends Area

var areas = []

func _on_CanPickUp_area_entered(area):
	if area.is_in_group("can_be_picked_up"):
		areas.push_back(area)
	pass


func _on_CanPickUp_area_exited(area):
	if area.is_in_group("can_be_picked_up"):
		areas.erase(area)
	pass
