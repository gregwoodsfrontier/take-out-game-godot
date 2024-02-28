extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

@export var speed : float = 50.0

var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true
	

func _process(delta):
	update_animation_params()

func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func update_animation_params():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/isWalking"] = false
	else:
		animation_tree["parameters/conditions/isWalking"] = true
		animation_tree["parameters/conditions/idle"] = false
	
	# dont update directione when key is released
	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
