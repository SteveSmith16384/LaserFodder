extends CSGPolygon


func _ready():
	var mat = self.material
	self.material = mat.duplicate()
	pass
