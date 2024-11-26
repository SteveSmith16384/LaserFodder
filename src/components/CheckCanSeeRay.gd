extends RayCast


func _ready():
	#self.exclude_parent = true
	# todo self.enabled = false
	pass
	
	
func can_see_target(target: Spatial):
	var hit = can_see_point(target.global_translation - self.global_translation)
	return hit == target or hit == null
	
	
func can_see_point(point:Vector3):
	self.enabled = true
	self.cast_to = point
	self.cast_to.y = 0
	self.force_raycast_update()
	var hit = get_collider()
	#todo self.enabled = false
	return hit# == target or hit == null

