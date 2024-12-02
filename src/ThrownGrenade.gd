extends RigidBody


func _on_ExplodeTimer_timeout():
	EventBus.explosion(self.global_translation)
	self.queue_free()
	pass
