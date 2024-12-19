extends Area

var item_name: String = ""

func _ready():
	self.add_to_group("can_be_picked_up")
	pass


func _check_item_name():
	if item_name == "":
		var item = self.get_parent().get_node("IsItem")
		item_name = CreateEquipment.get_item_name(item.equipment_type)
		$Label3D.text = item_name
	pass
	
	
func _on_CanBePickedUp_body_entered(body):
	if body.is_in_group("player"):
		_check_item_name()
		EventBus.append_log("Unit is near " + item_name)
	pass


func _on_CanBePickedUp_mouse_entered():
	_check_item_name()
	$Label3D.visible = true
	pass


func _on_CanBePickedUp_mouse_exited():
	$Label3D.visible = false
	pass
