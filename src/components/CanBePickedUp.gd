extends Area

func _ready():
	self.add_to_group("can_be_picked_up")
	pass
	
func _on_CanBePickedUp_body_entered(_body):
	# todo -append log
	pass
