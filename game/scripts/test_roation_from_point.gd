extends RigidBody2D
@export var rotation_speed:float
@export var rotation_point:Node2D
@export var lenght:int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func new_coord_after_rotation(coord:Vector2,point:Vector2,angle:float)->Vector2:
	#angle = (angle * 2.0 * PI )/360.0
	#print(angle)
	var tmp_x:float = coord.x - point.x
	var tmp_y:float = coord.y - point.y
	var new_x = (tmp_x * cos(angle) - tmp_y*sin(angle))
	var new_y = (tmp_x*sin(angle) + tmp_y*cos(angle))
	return Vector2(new_x + point.x,new_y+ point.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_anything_pressed():
		print(delta)
		print(rotation_speed)
		var angle = rotation_speed * delta
		print(angle)
		rotation += angle
		#print(angle)
		position = new_coord_after_rotation(position,rotation_point.global_position,angle)
	pass
	

	
