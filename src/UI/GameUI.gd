extends CanvasLayer

const player_icon_class = preload("res://UI/UnitUIControl.tscn")

signal player_selected
signal pause_changed

var player_icons = {} # player::icon

func _ready():
	EventBus.connect("append_log", self, "_on_append_log")
	pass
	
	
func add_player_icon(player:Spatial):
	var icon = player_icon_class.instance()
	icon.init(player)
	$PlayerIcons.add_child(icon)
	icon.connect("player_selected", self, "_on_player_selected")
	#icon.connect("action_mode_changed", self, "_on_action_mode_changed")
	
	player_icons[player] = icon
	pass


func _on_player_selected(player):
	emit_signal("player_selected", player)
	
	# Show unit stats
	var unit_data :UnitData = player.get_node("UnitData")
	$UnitStats.clear_log()
	$UnitStats.text = unit_data.unit_name + "\n"
	$UnitStats.text += "Armour: " + str(int(unit_data.armour)) + "%\n"
	$UnitStats.text += "Acc: " + str(int(unit_data.accuracy)) + "%\n"
	$UnitStats.text += "Health: " + str(int(unit_data.health)) + "\n"
	pass
	

func _on_PauseButton_toggled(button_pressed):
	emit_signal("pause_changed", button_pressed)
	pass


func select_player(player):
	for ch in $PlayerIcons.get_children():
		if ch.player == player:
			ch.set_pressed(true)
		else:
			ch.set_pressed(false)
	pass
	

func _on_append_log(s:String):
	$Log.append_to_log(s)
	pass
	
