extends CharacterBody2D
@export var speed = 480
var screen_size
signal hit
signal tract_anchor(new_velocity)

var direct_vect = Vector2.ZERO
var dist = -INF
@export var lenght_rope = 0
@export var anchor_point: Node2D
@export var player_anchor_point: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

func rotate_vect_90(vect):
	var new_vect = Vector2.ZERO
	
	new_vect.x = -vect.y
	new_vect.y = vect.x
	return new_vect

# Project the vactor a on the vector b and return the value
func project_vector_on_vector(a,b):
	return (a.dot(b)/b.dot(b))*b

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
		
	if velocity.length() >0:
		velocity = velocity.normalized()*speed
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):#this version tract the ankor with the player
	get_input()
	dist = (player_anchor_point.global_position).distance_to(anchor_point.global_position)
	if(dist >= lenght_rope):# Must ²block movement inisde rope range
		print_debug("in it")
		#vector line between anchor an player
		direct_vect = (player_anchor_point.global_position - anchor_point.global_position).normalized()
		print("rotate_before",direct_vect)
		if(velocity.dot(direct_vect) > 0): # Velocity is going out of range of rope
			#direct_vect = rotate_vect_90(direct_vect)
			#print("rotate_after",direct_vect)
			#print_debug("old velocity",velocity)
			velocity = velocity/2
			#print_debug("new velocity",velocity)
			tract_anchor.emit(project_vector_on_vector(velocity,direct_vect)*delta)
	var collision_info = move_and_collide(velocity * delta)
	position = position.clamp(Vector2.ZERO,screen_size)
	#dist = position.distance_to(anchor_point.position)
	
	#print_debug(dist)
	pass

func old_physics_process(delta): # This version blocks the player in its movement
	get_input()
	dist = (player_anchor_point.global_position).distance_to(anchor_point.global_position)
	if(dist >= lenght_rope):# Must ²block movement inisde rope range
		print_debug("in it")
		#vector line between anchor an player
		direct_vect = (player_anchor_point.global_position - anchor_point.global_position).normalized()
		print("rotate_before",direct_vect)
		if(velocity.dot(direct_vect) > 0): # Velocity is going out of range of rope
			direct_vect = rotate_vect_90(direct_vect)
			print("rotate_after",direct_vect)
			print_debug("old velocity",velocity)
			velocity = project_vector_on_vector(velocity,direct_vect)
			print_debug("new velocity",velocity)
	var collision_info = move_and_collide(velocity * delta)
	position = position.clamp(Vector2.ZERO,screen_size)
	#dist = position.distance_to(anchor_point.position)
	
	#print_debug(dist)
	pass
