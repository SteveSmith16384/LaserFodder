extends CanvasLayer

const player_icon_class = preload("res://UI/UnitUIControl.tscn")

signal player_selected

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
	
