extends Control # todo - delete?

func init(item):
	var is_item = item.get_node("IsItem")
	$VBoxContainer/Name.text = is_item.item_name
	var is_gun = item.find_node("IsGun", false)
	if is_gun:
		$VBoxContainer/AmmoProgressBar.max_value = is_gun.max_ammo
		$VBoxContainer/AmmoProgressBar.value = is_gun.get_ammo()
		$VBoxContainer/Name.text += " " + str(is_gun.get_ammo()) + "/" + str(is_gun.max_ammo)
		pass
	else:
		$VBoxContainer/AmmoProgressBar.visible = false
	pass
	
