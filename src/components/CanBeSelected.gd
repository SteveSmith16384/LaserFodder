extends Spatial

signal selected

func _ready():
#	var parent: Spatial = self.get_parent()
#	parent.connect("mouse_entered", self, "_on_mouse_entered")
#	parent.connect("mouse_exited", self, "_on_mouse_exited")

	$Ring.visible = false
	pass
	
	
func _on_CanBeSelected_mouse_entered():
	if get_parent().visible == false:
		return
	$Ring.visible = true
	pass


func _on_CanBeSelected_mouse_exited():
	$Ring.visible = false
	pass


func _on_CanBeSelected_input_event(_camera, event, _position, _normal, _shape_idx):
	if get_parent().visible == false:
		return

	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("selected")
		pass
	pass
