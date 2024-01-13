func rotateVect(v,angle):
	var newVect = Vector2.ZERO
	newVect.x = v.x*cos(angle)-v.y*sin(angle)
	newVect.y = v.x*sin(angle)+v.y*cos(angle)
	return newVect
	
func angleBtVect(u:Vector2,v:Vector2):
	return acos((u.dot(v)/(u.length()*v.length())))

# Gives the new coordinates of a point after rotation from point of angle
func new_coord_after_rotation(coord:Vector2,point:Vector2,angle:float)->Vector2:
	#angle = (angle * 2.0 * PI )/360.0
	#print(angle)
	var tmp_x:float = coord.x - point.x
	var tmp_y:float = coord.y - point.y
	var new_x = (tmp_x * cos(angle) - tmp_y*sin(angle))
	var new_y = (tmp_x*sin(angle) + tmp_y*cos(angle))
	return Vector2(new_x + point.x,new_y+ point.y)

#function used to add a piece of rope in the middle, we need the angle
#to rorate the pieces so the new one fit exactly
#the base is the distance of the two joint of the old pieces
#the edge is the lenght between two joints in a piece
func compute_angle_of_trapeze(base:float,edge:float):
	var diag = sqrt(base*edge + edge**2)
	var alpha = acos((edge**2 + base**2 - diag**2)/(2*edge*base))
	return alpha
