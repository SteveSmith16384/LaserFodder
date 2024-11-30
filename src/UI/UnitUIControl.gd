extends Control

var carriedicon_class = preload("res://UI/UICarriedIcon.tscn")

signal player_selected

var player : KinematicBody

func init(player_:Spatial):
	player = player_
	pass
	

func _on_SelectButton_pressed():
	$VBoxContainer/SelectButton.accept_event()
	#get_tree().set_input_as_handled()
	emit_signal("player_selected", player)
	pass


func update_stats():
	var cbs = player.get_node("CanBeShot")
	$VBoxContainer/HealthProgressBar.value = cbs.health
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
	
