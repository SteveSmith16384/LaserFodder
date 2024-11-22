extends Spatial


func walk():
	$AnimationPlayer.play("Walk", 0, 1.5)
	pass


func idle():
	$AnimationPlayer.play("Idle")
	pass


func shot():
	if Globals.rnd.randi_range(1, 2) == 1:
		$AnimationPlayer.play("HitRecieve")
	else:
		$AnimationPlayer.play("HitRecieve_2")
	pass


func shoot_anim():
	$AnimationPlayer.play("Gun_Shoot")
	pass
	
	
func killed():
	$AnimationPlayer.play("Death")
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Walk" or anim_name == "Idle":
		$AnimationPlayer.play(anim_name)
#	if anim_name == "Walk":
#		walk()
#	elif anim_name == "Death":
#		# Do nothing
#		pass
#	else:
#		idle()
	pass
