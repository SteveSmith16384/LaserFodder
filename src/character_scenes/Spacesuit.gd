extends Spatial

func idle():
	$AnimationPlayer.play("Idle")
	pass


func walk():
	$AnimationPlayer.play("Walk")
	pass


func run():
	$AnimationPlayer.play("Run")
	pass


func shoot():
	$AnimationPlayer.play("Gun_Shoot")
	pass


func shot():
	if Globals.rnd.randi_range(1, 2) == 1:
		$AnimationPlayer.play("HitRecieve")
	else:
		$AnimationPlayer.play("HitRecieve_2")
	pass


func killed():
	$AnimationPlayer.play("Death")
	pass


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "Walk" or anim_name == "Idle":
		$AnimationPlayer.play(anim_name)
	pass
