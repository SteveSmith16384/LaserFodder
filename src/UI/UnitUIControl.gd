extends Control

signal player_selected

var player : KinematicBody

func init(player_:Spatial):
	player = player_
	
	var unit_data = player.get_node("UnitData")
	$VBoxContainer/SelectButton.text = unit_data.unit_name
	
	player.connect("health_changed", self, "_on_health_changed")
	player.connect("equipment_changed2", self, "_on_equipment_changed")
	pass
	

func _on_SelectButton_pressed():
	$VBoxContainer/SelectButton.accept_event()
	#get_tree().set_input_as_handled()
	emit_signal("player_selected", player)
	pass


func _on_health_changed():
	var ud = player.get_node("UnitData")
	$VBoxContainer/HealthProgressBar.max_value = ud.max_health
	$VBoxContainer/HealthProgressBar.value = ud.health
	pass
	

func _on_equipment_changed():
	_update_equipment()
	pass
	
	
func _update_equipment():
#	for icon in $VBoxContainer/CarriedItems.get_children():
#		icon.queue_free()
	
	$VBoxContainer/CarriedItems.clear()
	var idx :int= 0
	var can_carry = player.get_node("CanCarry")
	for item in can_carry.items:
		#var icon = carriedicon_class.instance()
		#icon.init(item)
		var item_name: String = _get_item_text(item)
		$VBoxContainer/CarriedItems.add_item(item_name, idx)
		#$VBoxContainer/OptionButton.add_child(icon)
		idx += 1
	pass
	

func _get_item_text(item):
	var is_item = item.get_node("IsItem")
	#$VBoxContainer/Name.text = is_item.item_name
	var is_gun = item.find_node("IsGun", false)
	if is_gun != null:
#		$VBoxContainer/AmmoProgressBar.max_value = is_gun.max_ammo
#		$VBoxContainer/AmmoProgressBar.value = is_gun.get_ammo()
#		$VBoxContainer/Name.text += " " + str(is_gun.get_ammo()) + "/" + str(is_gun.max_ammo)
		return is_item.item_name + " " + str(is_gun.get_ammo()) + "/" + str(is_gun.max_ammo)
	else:
		#$VBoxContainer/AmmoProgressBar.visible = false
		return is_item.item_name


func _on_CarriedItems_item_selected(index):
	var can_carry = player.get_node("CanCarry")
	can_carry.current_item = can_carry.items[index]
	pass
