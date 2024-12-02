extends Spatial

export (NodePath) var to_remove
export var remove_self = false

func _ready():
	for child in get_children():
		child.visible = false
	pass
	

func caught_in_explosion():
	if remove_self:
		self.queue_free()
		return

	if to_remove != null:
		var node = get_node(to_remove)
		node.queue_free()
	
	for child in get_children():
		child.visible = true

	# Disabled collision mesh
	for child in get_parent().get_children():
		if "disabled" in child:
			child.disabled = true
	pass
	
