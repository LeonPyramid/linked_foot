extends Node

var Math = preload("res://scripts/Math.gd").new()

@export var piece_one:Node2D
@export var piece_two:Node2D
@export var joint_one:Node2D
@export var joint_two:Node2D
@export var test_joint_two:Node2D
@export var joint_three:Node2D
var one = true

func rotate_object_arround(obj:Node2D,point:Vector2,angle:float):
	obj.rotation += angle
	#print(angle)
	obj.position = Math.new_coord_after_rotation(obj.position,point,angle)

# Called when the node enters the scene tree for the first time.
func _ready():
	one = true
	pass # Replace with function body.

# Rotate the two pieces of rope so they can add one new piece between them
# piece1 and piece2 are the rope piece to rotate
# joint_1 and joint_3 are the two rotation point of the ropes
# dist_joint is the usual distance between two joints in the rope
func _leave_space_for_new_rope(piece_1:Node2D,
			piece_2:Node2D,joint_1:Node2D,joint_3:Node2D,dist_joint:float):
	var space = joint_one.position.distance_to(joint_three.position)
	var angle = Math.compute_angle_of_trapeze(space,dist_joint)
	rotate_object_arround(piece_1,joint_1.position,angle)
	rotate_object_arround(piece_2,joint_3.position,-angle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_anything_pressed() && one:
		one = false
		var length = joint_one.position.distance_to(joint_two.position)
		var dist = joint_one.position.distance_to(joint_three.position)
		var angle = Math.compute_angle_of_trapeze(dist,length)
		rotate_object_arround(piece_one,joint_one.position,angle)
		rotate_object_arround(piece_two,joint_three.position,-angle)
		rotate_object_arround(test_joint_two,joint_three.position,-angle)
		print("length between one and two:",length)
		print("length between two and test",joint_two.position.distance_to(test_joint_two.position))
		
