extends VBoxContainer

signal unit_selected

func init(nm:String):
	$NameButton.text = nm
	
	$ArmourSelection.add_item("Light Armour")
	$ArmourSelection.add_item("Medium Armour")
	$ArmourSelection.add_item("Heavy Armour")
	pass


func _on_NameButton_pressed():
	emit_signal("unit_selected", self)
	pass


func set_pressed(b:bool):
	$NameButton.set_pressed(b)
	pass

