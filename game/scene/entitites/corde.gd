extends Node2D

const Math = preload("res://scripts/Math.gd")
var util =Math.new()

var Piece = preload("res://scene/entitites/bout_corde.tscn")


var extremity1
var extremity2
var list_pieces:Array[RigidBody2D]= []
var nb_pieces = 0
var list_joint = []
var number_joints = 0
var dist_overlap_joint = 0

var length=0

func _move_extremities():
	pass
func add_piece():
	var piece = Piece.instantiate()
	get_parent().add_child(piece)
	piece.id = nb_pieces
	nb_pieces+=1
	var direction = extremity2-extremity1.normalised()
	
	
	if (nb_pieces==1): 
		# Créer un joint en extreme A et piece
		# Mettre pièce vers extreme B
		piece.position= direction*piece.length
		#ROTATER 
		
func remove_piece():
	pass
func generate_rope(nb_pieces):
	pass


