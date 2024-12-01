extends Control

var carriedicon_class = preload("res://UI/UICarriedIcon.tscn")

signal player_selected

var player : KinematicBody

func init(player_:Spatial):
	player = player_
	
	var unit_data = player.get_node("UnitData")
	$VBoxContainer/SelectButton.text = unit_data.unit_name
	
	player.connect("health_changed", self, "_on_health_changed")
	player.connect("equipment_changed", self, "_on_equipment_changed")
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
	#todo
	pass
	
	
func update_equipment():
	for icon in $VBoxContainer/CarriedItems.get_children():
		icon.queue_free()
		
	var can_carry = player.get_node("CanCarry")
	for item in can_carry.items:
		var icon = carriedicon_class.instance()
		icon.init(item)
		$VBoxContainer/CarriedItems.add_child(icon)
	pass
	
