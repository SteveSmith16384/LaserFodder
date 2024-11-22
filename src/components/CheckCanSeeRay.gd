extends RayCast


func _ready():
	self.exclude_parent = true
	self.enabled = false
	pass
	
	
func can_see(target: Spatial):
	self.enabled = true
	self.cast_to = target.global_translation - self.global_translation
	self.cast_to.y = 0
	self.force_raycast_update()
	var hit = get_collider()
	return hit == target or hit == null
