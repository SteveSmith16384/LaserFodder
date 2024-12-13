extends Control

signal player_selected
#signal action_mode_changed

var player : KinematicBody

func init(player_:Spatial):
	player = player_
	
	var unit_data = player.get_node("UnitData")
	$VBoxContainer/SelectButton.text = unit_data.unit_name
	
	player.connect("health_changed", self, "_on_health_changed")
	player.connect("equipment_changed2", self, "_on_equipment_changed")
	
	$VBoxContainer/ActionMode.add_item("Stop on Sight")
	$VBoxContainer/ActionMode.add_item("Keep Moving")
	$VBoxContainer/ActionMode.add_item("Run!")
	pass
	

func _on_SelectButton_pressed():
	$VBoxContainer/SelectButton.accept_event()
	emit_signal("player_selected", player)
	pass


func _on_health_changed(_pl):
	var ud = player.get_node("UnitData")
	if ud.killed:
		#self.visible = false
		self.modulate.a = 0.3
	else:
		$VBoxContainer/HealthProgressBar.max_value = ud.max_health
		$VBoxContainer/HealthProgressBar.value = ud.health
	
	pass
	

func _on_equipment_changed():
	_update_equipment()
	pass
	
	
func _update_equipment():
	$VBoxContainer/CarriedItems.clear()
	var idx :int= 0
	var can_carry = player.get_node("CanCarry")
	for item in can_carry.items:
		var item_name: String = _get_item_text(item)
		$VBoxContainer/CarriedItems.add_item(item_name, idx)
		idx += 1
	pass
	

func _get_item_text(item):
	var is_item = item.get_node("IsItem")
	var is_gun = item.find_node("IsGun", false)
	if is_gun != null:
		return is_item.item_name + " " + str(is_gun.get_ammo()) + "/" + str(is_gun.max_ammo)
	else:
		return is_item.item_name


func _on_CarriedItems_item_selected(index):
	var can_carry = player.get_node("CanCarry")
	can_carry.current_item = can_carry.items[index]
	pass


func set_pressed(b:bool):
	$VBoxContainer/SelectButton.set_pressed(b)
	pass


func _on_ActionMode_item_selected(index):
	var unit_data = player.get_node("UnitData")
	unit_data.action_mode = index
	#emit_signal("action_mode_changed", player, index)
	
	pass

