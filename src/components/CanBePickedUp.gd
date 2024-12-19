extends Area

export (CreateEquipment.EquipType) var equipment_type

func _on_CanBePickedUp_body_entered(body):
	if body.is_in_group("player"):
		var can_carry = body.get_node("CanCarry")
		if can_carry == null:
			return
		var eq = CreateEquipment.get_equipment(equipment_type)
		can_carry.items.push_back(eq)
		body.emit_signal_equipment_changed()

		EventBus.append_log(eq.get_node("IsItem").item_name + " picked up")

		get_parent().queue_free()
		pass
		
	pass
