extends Node

signal explosion
signal player_selected
signal append_log

func explosion(pos:Vector3, rad:float, dmg:float):
	emit_signal("explosion", pos, rad, dmg)
	pass
	
	
func player_selected(player):
	emit_signal("player_selected", player)
	pass
	

func append_log(s:String):
	emit_signal(s)
	pass
	
	
