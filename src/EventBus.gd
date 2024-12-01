extends Node

signal explosion

#signal player_selected
#signal enemy_selected

func player_selected(_player:Spatial):
	#emit_signal("player_selected", player)
	pass
	
	
func enemy_selected(_enemy:Spatial):
	#emit_signal("enemy_selected", enemy)
	pass
	

func explosion(pos:Vector3):
	emit_signal("explosion", pos)
	pass
	
	
