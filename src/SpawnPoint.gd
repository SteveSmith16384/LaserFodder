extends Position3D

enum Character {CIV, POLICE, ENEMY_AGENT, PLAYER}

export(Character) var character


func _ready():
	if character == Character.PLAYER:
		#get_parent().create_player(self.translation)
		get_parent().call_deferred("create_player", self.translation)
	pass
	
	
func _on_VisibilityNotifier_camera_exited(_camera):
	match character:
		Character.CIV:
			get_parent().create_civ(self.translation)
		Character.POLICE:
			get_parent().create_police(self.translation)
		Character.ENEMY_AGENT:
			get_parent().create_enemy(self.translation)
	pass
	
