extends Node

signal enemy_selected

func enemy_selected(enemy:Spatial):
	emit_signal("enemy_selected", enemy)
	pass
	
	
