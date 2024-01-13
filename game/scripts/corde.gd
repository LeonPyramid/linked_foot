extends Node2D

var extremity1
var extremity2
var list_pieces = []
@export var number_pieces = 0
var list_joint = []
var number_joints = 0
var dist_overlap_joint = 0

var length=0

func _move_extremities():
	pass
func add_piece():
	pass
func remove_piece():
	pass
func generate_rope(nb_pieces):
	pass

func _rotate_from_point(ojbect:RigidBody2D,point):
	pass


# Rotate the two pieces of rope so they can add one new piece between them
# piece1 and piece2 are the rope piece to rotate
# joint_1 and joint_3 are the two rotation point of the ropes
# dist_joint is the usual distance between two joints in the rope
func leave_space_for_new_rope(piece_1:Node2D,
			piece_2:Node2D,joint_1:Node2D,joint_3:Node2D,dist_joint:float):
	var space = joint_one.position.distance_to(joint_three.position)
	var angle = Math.compute_angle_of_trapeze(space,dist_joint)
	rotate_object_arround(piece_1,joint_1.position,angle)
	rotate_object_arround(piece_2,joint_3.position,-angle)
