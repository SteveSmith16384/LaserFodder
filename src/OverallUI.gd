extends CanvasLayer

func _process(_delta):
	if Globals.SHOW_FPS:
		$FPSLabel.text = "FPS:" + str(Engine.get_frames_per_second())
	pass
