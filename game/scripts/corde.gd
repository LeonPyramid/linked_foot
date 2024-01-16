extends Node2D

var Math = preload("res://scripts/Math.gd").new()


var Piece = preload("res://scene/entitites/bout_corde.tscn")

## distance between the two extremities
@export var distance=0 

## the two extremitites of the rope
@export var extremity1:Node2D
@export var extremity2:Node2D

## The pieces of the rope
var list_pieces:Array[RigidBody2D]= []
@export var nb_pieces:int= 0 # Will be computed from the distance at rope generation

var list_joint:Array[PinJoint2D] = []
var nb_joints:int = 0

## Number of pixel the pieces will overlap each other (to connect the joint)
@export var dist_overlap_joint = 2

## Compute the distance between the joints in the rope
var joint_distance:int

## Signal when the rope change length
signal rope_change(length:int)

	
## Add a joint between obj1 and obj2 at pos_in_obj1 in obj1, and set the joint as child of obj1
func _add_joint(joint,obj1,obj2,pos_in_obj1):
	joint.node_a = obj1.get_path()
	obj1.add_child(joint)
	joint.position = pos_in_obj1
	joint.node_b = obj2.get_path()
	joint.disable_collision = true
	joint.bias = 0.9
	

## Compute the position of the piece corresponding to the optimal high tension rope
func _compute_piece_position(piece,id,direction):
	return direction*(0.5*piece.length - dist_overlap_joint + id * (joint_distance))


func _move_extremities(length):
	var directionE1 = (extremity2.global_position-extremity1.global_position).normalized()
	var directionE2 = -directionE1 
	extremity1.get_parent().global_position += directionE1*(length/2) # TODO : Need to treat this more clean
	extremity2.global_position += directionE2*(length/2)
	
	
## Compute the angle in the isosceles rectangle between base and
## edges, where base is distance_to_joint and edges are joint_distance_in_piece
func _angle_overlap(joint_distance_in_piece,distance_to_joint):
	return acos((distance_to_joint**2)/(2.0*(joint_distance_in_piece)*distance_to_joint))


func add_piece():
	## General creation of a piece
	var piece = Piece.instantiate()
	add_child(piece)
	piece.id = len(list_pieces)
	list_pieces.append(piece)
	
	
	var joint = PinJoint2D.new()
	nb_joints+=1
	list_joint.append(joint)
	
	
	var direction = (extremity2.global_position-extremity1.global_position).normalized()
	
	
	
	var vectorPiece = Vector2(0,piece.length)
	var rotationPoint = extremity1.global_position
	var angleRotation = Math.angleBtVect(vectorPiece,direction)
	
	## Case of the first piece
	if (piece.id==0): 
		var piecePostion = rotationPoint + _compute_piece_position(piece,piece.id,direction)
		#var coordRotation = Math.new_coord_after_rotation(piecePostion,rotationPoint,-angleRotation)
		piece.global_position= piecePostion
		
		piece.rotation -= (angleRotation)
		
		_add_joint(joint,extremity1,piece,Vector2.ZERO)
		
	## General case
	else:
		# General computation
		var joint_pos_in_piece = Vector2(0,0.5*(piece.length-2*dist_overlap_joint)+ 0.5*dist_overlap_joint)
		var rope_length = (piece.id+1)*(joint_distance)+0.5*dist_overlap_joint

	## We have an overlap of rope length, need to angle the last piece and joint with the extremity2
		if(rope_length>distance):
			var piece_id_m_1 = list_pieces[piece.id-1]
			var ancestor_joint_pos = list_joint[piece.id-1].global_position # we need this joint as
			# a pivot point for the piece id-1
			
			# Compute the distance to cover and the new angle of the pieces
			var dist_ancest_extrem = ancestor_joint_pos.distance_to(extremity2.global_position)
			var angle_overlap =  _angle_overlap(joint_distance,dist_ancest_extrem)
			
			# Making pivot the previous rope point
			var new_pos_id_m_1 = Math.new_coord_after_rotation(
				piece_id_m_1.global_position,ancestor_joint_pos,angle_overlap)
			piece_id_m_1.global_position = new_pos_id_m_1
			piece_id_m_1.rotation += angle_overlap
			
			# Making pivot the new rope point
			var new_piece_position = extremity2.global_position -direction*0.5*(joint_distance)
			new_piece_position = Math.new_coord_after_rotation(
				new_piece_position,extremity2.global_position,-angle_overlap)
			piece.global_position = new_piece_position
			piece.rotation -= angleRotation + angle_overlap

	## General case, add after the previous one
		else:
			var piecePostion = rotationPoint + _compute_piece_position(piece,piece.id,direction)
			piece.global_position = piecePostion
			piece.rotation -= angleRotation
		
		_add_joint(joint,list_pieces[piece.id-1],piece,joint_pos_in_piece)
		
		if(rope_length>distance && list_joint[nb_joints - 1].node_b != extremity2.get_path()):
			# Need to joint to the extremity
			var joint_end = PinJoint2D.new()
			nb_joints+=1
			list_joint.append(joint_end)
			_add_joint(joint_end,piece,extremity2,joint_pos_in_piece)
	# TODO: treat the case where the rope is added in the middle (i.e. extremities are connected)
		
func remove_piece():
	pass

## Destroy the previous builded rope
func _delete_rope():
	for piece in list_pieces:
		piece.queue_free()
	list_pieces = []
	for joint in list_joint:
		joint.queue_free()
	list_joint = []
	nb_pieces = 0
	nb_joints = 0
	


func generate_rope(nb_pieces):
	for i in range(nb_pieces):
		add_piece()

func _ready():
	#extremity2 = get_parent().get_node("AnchorPoint")
	#extremity1 = get_parent().get_node("CharacterBody2D").get_node("AnchorPoint")
	
	distance = 0
	nb_pieces = 0
	nb_joints = 0
	
	# Need to instantiate a piece of rope to know the length
	var piece_loc = Piece.instantiate()
	joint_distance = piece_loc.length -dist_overlap_joint
	piece_loc.free()
	

func _input(event):
	if(Input.is_action_just_pressed("general_event")):
		_delete_rope()
		# Computing the length of the rope
		distance = extremity1.global_position.distance_to(extremity2.global_position)
		nb_pieces = ceil(distance/joint_distance)
		print_debug("dist: ",distance,"\n rope_length: ",nb_pieces* joint_distance)
		generate_rope(nb_pieces)
		rope_change.emit(nb_pieces * joint_distance)
		
	if(Input.is_action_just_pressed("remove")):
		_delete_rope()
		rope_change.emit(INF)
		
func _physics_process(delta):
	pass

# Rotate the two pieces of rope so they can add one new piece between them
# piece1 and piece2 are the rope piece to rotate
# joint_1 and joint_3 are the two rotation point of the ropes
# dist_joint is the usual distance between two joints in the rope
func leave_space_for_new_rope(piece_1:Node2D,
	piece_2:Node2D,joint_1:Node2D,joint_3:Node2D,dist_joint:float):
	var space = joint_1.position.distance_to(joint_3.position)
	var angle = Math.compute_angle_of_trapeze(space,dist_joint)
	Math.rotate_object_arround(piece_1,joint_1.position,angle)
	Math.rotate_object_arround(piece_2,joint_3.position,-angle)

