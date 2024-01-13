func rotateVect(v,angle):
	var newVect = Vector2.ZERO
	newVect.x = v.x*cos(angle)-v.y*sin(angle)
	newVect.y = v.x*sin(angle)+v.y*cos(angle)
	return newVect
	
func angleBtVect(u:Vector2,v:Vector2):
	return acos((u.dot(v)/(u.length()*v.length())))
