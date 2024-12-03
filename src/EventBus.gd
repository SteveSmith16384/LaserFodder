extends Node

signal explosion

func explosion(pos:Vector3):
	emit_signal("explosion", pos)
	pass
	
	
