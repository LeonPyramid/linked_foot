extends Node2D

var Math = preload("res://scripts/Math.gd").new()


var Piece = preload("res://scene/entitites/bout_corde.tscn")

@export var distance=0


var extremity1
var extremity2
var list_pieces:Array[RigidBody2D]= []

@export var nb_pieces:int= 0
var list_joint:Array[PinJoint2D] = []
var nb_joints:int = 0
@export var dist_overlap_joint = 2



	
#Add a joint between obj1 and obj2 at pos_in_obj1 in obj1, and set the joint as child of obj1
func _add_joint(joint,obj1,obj2,pos_in_obj1):
	joint.node_a = obj1.get_path()
	obj1.add_child(joint)
	joint.position = pos_in_obj1
	joint.node_b = obj2.get_path()
	joint.disable_collision = true
	joint.bias = 0.9
	

func _compute_piece_position(piece,id,direction):
	return direction*(0.5*piece.length - dist_overlap_joint + id * (piece.length - dist_overlap_joint))


func _move_extremities(length):
	var directionE1 = (extremity2.global_position-extremity1.global_position).normalized()
	var directionE2 = -directionE1 
	extremity1.get_parent().global_position += directionE1*(length/2)
	extremity2.global_position += directionE2*(length/2)
	
	

func add_piece():
	var piece = Piece.instantiate()
	add_child(piece)
	piece.id = len(list_pieces)
	nb_pieces+=1
	list_pieces.append(piece)
	
	
	var joint = PinJoint2D.new()
	nb_joints+=1
	list_joint.append(joint)
	
	
	var direction = (extremity2.global_position-extremity1.global_position).normalized()
	print("direction:",direction)
	
	
	var vectorPiece = Vector2(0,piece.length)
	var rotationPoint = extremity1.global_position
	var angleRotation = Math.angleBtVect(vectorPiece,direction)
	print(angleRotation)
	if (piece.id==0): 
		var piecePostion = rotationPoint + _compute_piece_position(piece,piece.id,direction)
		#var coordRotation = Math.new_coord_after_rotation(piecePostion,rotationPoint,-angleRotation)
		#print(piecePostion, coordRotation)
		piece.global_position= piecePostion
		
		piece.rotation -= (angleRotation)
		
		_add_joint(joint,extremity1,piece,Vector2.ZERO)
		
	elif (len(list_pieces)==nb_pieces):
		pass #TODO: faire le code quand dernière pièce
	else:
		var joint_pos_in_piece = Vector2(0,0.5*(piece.length-2*dist_overlap_joint)+ 0.5*dist_overlap_joint)
		
		print("distance:",distance)
		var rope_length = (piece.id+1)*(piece.length-dist_overlap_joint)+0.5*dist_overlap_joint
		print("length:",rope_length)
		if(rope_length>distance):
			var piece_id_m_1 = list_pieces[piece.id-1]
			var ancestor_joint_pos = list_joint[piece.id-1].global_position # we need this joint as
			# a pivot point for the piece id-1
			var dist_ancest_extrem = ancestor_joint_pos.distance_to(extremity2.position)
			var angle_overlap = acos((dist_ancest_extrem**2)/(2.0*piece.length*dist_ancest_extrem))
			var new_pos_id_m_1 = Math.new_coord_after_rotation(
				piece_id_m_1.global_position,ancestor_joint_pos,angle_overlap)
			piece_id_m_1.global_position = new_pos_id_m_1
			piece_id_m_1.rotation += angle_overlap
			var new_piece_position = extremity2.global_position -direction*(0.5*piece.length - dist_overlap_joint)
			new_piece_position = Math.new_coord_after_rotation(
				new_piece_position,extremity2.global_position,-angle_overlap)
			
			piece.global_position = new_piece_position
			piece.rotation -= angle_overlap + angleRotation
			#piece.rotation += 2*angle_overlap

		else:
			var piecePostion = rotationPoint + _compute_piece_position(piece,piece.id,direction)
			
			piece.global_position = piecePostion
			
			piece.rotation -= angleRotation
		_add_joint(joint,list_pieces[piece.id-1],piece,joint_pos_in_piece)
		if(rope_length>distance):
			var joint_end = PinJoint2D.new()
			nb_joints+=1
			list_joint.append(joint_end)
			_add_joint(joint_end,piece,extremity2,joint_pos_in_piece)
		
		
func remove_piece():
	pass
func generate_rope(nb_pieces):
	for i in range(nb_pieces):
		add_piece()

func _ready():
	extremity2 = get_parent().get_node("AnchorPoint")
	extremity1 = get_parent().get_node("CharacterBody2D").get_node("AnchorPoint")
	distance = extremity1.global_position.distance_to(extremity2.global_position)
	print_debug(nb_pieces)
	generate_rope(nb_pieces)
	
	pass # Replace with function body.

func _physics_process(delta):
	if(Input.is_anything_pressed()):
		_move_extremities(20*delta)

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

