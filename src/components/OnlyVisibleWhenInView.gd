extends Spatial

export var stay_visible = true

func _ready():
	get_parent().visible = false
	pass
	

func _on_CheckViewTimer_timeout():
	get_parent().visible = false
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		var can_see:bool = $CheckCanSeeRay.can_see_target(player)
		if can_see:
			get_parent().visible = true
			if stay_visible:
				$CheckViewTimer.stop()
			break
	pass
