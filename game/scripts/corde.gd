extends Node2D

var Math = preload("res://scripts/Math.gd").new()


var Piece = preload("res://scene/entitites/bout_corde.tscn")

@export var length=0


var extremity1
var extremity2
var list_pieces:Array[RigidBody2D]= []

@export var nb_pieces:int= 0
var list_joint:Array[PinJoint2D] = []
var nb_joints:int = 0
@export var dist_overlap_joint = 2


func _move_extremities():
	pass
func add_piece():
	print_debug("INNN")
	var piece = Piece.instantiate()
	add_child(piece)
	piece.id = nb_pieces
	nb_pieces+=1
	list_pieces.append(piece)
	print_debug(list_pieces)
	
	
	var joint = PinJoint2D.new()
	nb_joints+=1
	list_joint.append(joint)
	
	
	var direction = (extremity2.global_position-extremity1.global_position).normalized()
	print("direction:",direction)
	
	
	if (len(list_pieces)==1): 
		print_debug(nb_pieces)
		var vectorPiece = Vector2(0,piece.length)
		var rotationPoint = extremity1.global_position
		var piecePostion = Vector2(rotationPoint.x,rotationPoint.y+0.5*piece.length-dist_overlap_joint)
		var angleRotation = Math.angleBtVect(vectorPiece,direction)
		print(angleRotation)
		var coordRotation = Math.new_coord_after_rotation(piecePostion,rotationPoint,angleRotation)
	
		piece.global_position= coordRotation
		
		piece.rotation+=angleRotation
		
		joint.node_a = extremity1.get_path()
		joint.node_b = piece.get_path()
		extremity1.add_child(joint)
		joint.position = Vector2.ZERO
		joint.disable_collision = true
		joint.bias = 0.9
		
		
func remove_piece():
	pass
func generate_rope(nb_pieces):
	for i in range(nb_pieces) :
		add_piece()

func _ready():
	extremity2 = get_parent().get_node("AnchorPoint")
	extremity1 = get_parent().get_node("CharacterBody2D").get_node("AnchorPoint")
	print_debug(nb_pieces)
	generate_rope(nb_pieces)
	pass # Replace with function body.




