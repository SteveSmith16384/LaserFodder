extends Spatial

const debug_class = preload("res://DebuggingSphere.tscn")

var astar:AStar

func generate_astar(sq_size:float):
	astar = AStar.new()
	
	var sx:float = self.translation.x
	var sz:float = self.translation.z
	var end_pos:Spatial = get_node("Position3D")
	var ex:float = end_pos.translation.x - sx
	var ez:float = end_pos.translation.z - sz
	
	var points_per_row:int = int((ex-sx) / sq_size) + 1
	var pointid: int = 0 # starts at 1

	var z:float = sz
	while z < ez:
		var x:float = sx
		while x < ex:
			pointid += 1
			astar.add_point(pointid, Vector3(x, 0, z))
			
			if pointid == 487:
				pass
				
			$RayCast.translation.x = x - self.translation.x
			$RayCast.translation.y = 0.1 # Keep below window level
			$RayCast.translation.z = z - self.translation.z
			
			#var debug:Spatial = debug_class.instance()
			#debug.translation = $CheckCanSeeRay.translation
			#self.add_child(debug)
			
			if x > sx:
				# Check West
				var can_see = _can_see_point(Vector3(-sq_size, 0, 0))
				if can_see == null:
					astar.connect_points(pointid, pointid - 1)
#					if pointid == 488:
#						return
				else:
					#print("Can't see")
					pass
				
			# Check North
			if z > sz:
				var can_see = _can_see_point(Vector3(0, 0, -sq_size))
				if can_see == null:
					astar.connect_points(pointid, pointid - points_per_row)
				else:
					#print("Can't see")
					pass
					
			x += sq_size
			pass
		pass
		z += sq_size
		
	Globals.astar = astar
	pass
	
	
func _can_see_point(point:Vector3):
	#self.enabled = true
	$RayCast.cast_to = point
	$RayCast.cast_to.y = 0
	$RayCast.force_raycast_update()
	var hit = $RayCast.get_collider()
	#todo self.enabled = false
	return hit# == target or hit == null
