extends StaticBody

func caught_in_explosion():
	$CubeMesh.visible = false
	$DestroyedWall.visible = true
	$CollisionShape.disabled = true
	pass
	
	
