extends Node

signal explosion
signal player_selected

func explosion(pos:Vector3, rad:float, dmg:float):
	emit_signal("explosion", pos, rad, dmg)
	pass
	
	
func player_selected(player):
	emit_signal("player_selected", player)
	pass
	
		
