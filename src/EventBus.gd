extends Node

signal explosion

func explosion(pos:Vector3, rad:float, dmg:float):
	emit_signal("explosion", pos, rad, dmg)
	pass
	
	
