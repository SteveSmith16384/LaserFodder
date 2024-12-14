extends Node2D

const uniteq_class = preload("res://UnitEquipmentControl.tscn")

var selected_unit

func _ready():
	for idx in 5:
		var uniteq = uniteq_class.instance()
		uniteq.connect("unit_selected", self, "_on_unit_selected")
		uniteq.init(Globals.get_unit_name(idx))
		$UnitEquipment.add_child(uniteq)
	
	add_equipment(CreateEquipment.EquipType.Pistol)
	pass


func _on_unit_selected(selected_unit_):
	selected_unit = selected_unit_
	for ch in $UnitEquipment.get_children():
		if ch == selected_unit:
			ch.set_pressed(true)
		else:
			ch.set_pressed(false)


func add_equipment(type: int):
	var carried_item = CreateEquipment.get_equipment(type)
	var name = carried_item.get_node("IsItem").item_name
	
	var button:= Button.new()
	button.text = name
	button.connect("pressed", self, "_on_purchase_pressed")
	$SelectEquipmentContainer.add_child(button)
	pass
	
	
func _on_purchase_pressed(btn):
	# todo
	pass
	
	
