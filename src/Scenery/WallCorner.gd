extends StaticBody


func caught_in_explosion():
	$MeshInstance.visible = false

	$CollisionShape.disabled = true
	$CollisionShape2.disabled = true
	pass
	
	
