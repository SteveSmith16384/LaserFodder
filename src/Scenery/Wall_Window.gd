extends StaticBody


func caught_in_explosion():
	$MeshInstance.visible = false

	$CollisionShape.disabled = true
	$CollisionShape2.disabled = true
	$CollisionShape3.disabled = true
	$CollisionShape4.disabled = true
	pass
	
	
