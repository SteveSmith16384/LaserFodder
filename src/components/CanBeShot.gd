extends Spatial

export var armour : float = 50 # Reduces damage by this percent
export var health : float = 100

signal shot
signal killed

var killed = false

func dec_health(shooter:Spatial, amt:float):
	amt = amt * armour / 100
	health -= amt
	if health <= 0:
		killed = true
		get_parent().get_node("CollisionShape").disabled = true
		emit_signal("killed", shooter)
	else:
		emit_signal("shot", shooter)
	pass
