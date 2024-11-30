extends CanvasLayer

const player_icon_class = preload("res://UI/UnitUIControl.tscn")
const carried_icon_class = preload("res://UI/UICarriedIcon.tscn")

signal player_selected
signal select_all

var player_icons = {} # player::icon

func add_player_icon(player:Spatial):
	var icon = player_icon_class.instance()
	icon.init(player)
	$PlayerIcons.add_child(icon)
	#icon.player = player
	icon.connect("player_selected", self, "_on_player_selected")
	
	player_icons[player] = icon
	pass


func _on_player_selected(player):
	emit_signal("player_selected", player)
	pass
	

func update_player_stats(player):
	player_icons[player].update_stats()
	pass
	

func update_player_equipment(player):
	player_icons[player].update_equipment()
	pass
	


func _on_SelectAllButton_pressed():
	emit_signal("select_all")
	pass
