extends RigidBody2D
@export var id = 0
@export var length = 20	

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("rope ",id," ready!")
	#if id %2 != 0:
		#get_node("Sprite2D").texture = load("res://sprite/rope.png")
	#else:
		#get_node("Sprite2D").texture = load("res://sprite/rope_white.png")
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
