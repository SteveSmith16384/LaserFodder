extends Spatial

func _ready():
	var parent: KinematicBody = self.get_parent()
	parent.connect("mouse_entered", self, "_on_mouse_entered")
	parent.connect("mouse_exited", self, "_on_mouse_exited")

	$MeshInstance.visible = false
	pass
	
	
func _on_mouse_entered():
	$MeshInstance.visible = true
	pass
	

func _on_mouse_exited():
	$MeshInstance.visible = false
	pass
	
	
