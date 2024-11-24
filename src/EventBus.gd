extends Node

signal player_selected
signal enemy_selected

func player_selected(player:Spatial):
	emit_signal("player_selected")
	pass
	
	
func enemy_selected(enemy:Spatial):
	emit_signal("enemy_selected", enemy)
	pass
	
	
