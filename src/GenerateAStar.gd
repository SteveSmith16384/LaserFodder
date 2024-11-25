extends Spatial

var astar:AStar#2D

func generate_astar(sx:float, sz:float, ex:float, ez:float, size:float):
	astar = AStar.new()#)2D.new()
	
	var points_per_row:int = int((ex-sx) / size)
	var pointid: int = 0

	var z:float = sz
	while z < ez:
		var x:float = sx
		while x < ex:
			pointid += 1
			astar.add_point(pointid, Vector3(x, 0, z))
			
			$CheckCanSeeRay.translation.x = x# + (size/2)
			$CheckCanSeeRay.translation.y = 0.5
			$CheckCanSeeRay.translation.z = z# + (size/2)
			
			if x > sx:
				# Check West
				var can_see = $CheckCanSeeRay.can_see_point(Vector3(-size, 0, 0))
				if can_see == null:
					astar.connect_points(pointid, pointid - 1)
					#return
				else:
					print("Can't see")
					pass

			# Check North
			if z > sz:
				var can_see = $CheckCanSeeRay.can_see_point(Vector3(0, 0, size))
				if can_see == null:
					astar.connect_points(pointid, pointid - points_per_row)
				else:
					print("Can't see")
					pass
					
			x += size
			pass
		pass
		z += size
		
	Globals.astar = astar
	pass
	
	
