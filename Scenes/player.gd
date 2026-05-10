extends CharacterBody2D

@export var speed = 500
@export var springFrequency = 10
@export var springDampingRatio = 1.0

@export var pokeForce: float = 15

var cPosition = 0
var cVelocity = 0
var cEquilibrium = 0

var movement_velocity = Vector3.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_input_handling(delta)
	_simulate_spring_motion(delta)
	_process_body_visuals()

func _process_body_visuals() -> void:
	#var children = _get_all_children($BodyBase)
	print("Process Body - Pos: ", cPosition, ". Vel: ", cVelocity)
	rotation = cPosition

func _get_all_children(node:Node) -> Array:
	var all_children := []
	for child in node.get_children():
		all_children.append(child)
		for grand_child in _get_all_children(child):
			all_children.append(grand_child)

	return all_children

func _input_handling(delta: float) -> void:
	if Input.is_action_just_pressed("poke"):
		cVelocity += pokeForce

	movement_velocity = Vector2(Input.get_axis("move_left", "move_right") * speed, 0);
	velocity = movement_velocity;
	move_and_slide()
	#cVelocity += movement_velocity.x * movementLeanFactor;

func _simulate_spring_motion(delta: float) -> void:
	print("Simulate spring - Pos: ", cPosition, ". Vel: ", cVelocity)
	spring_motion.CalcDampedSimpleHarmonicMotionFast(cPosition, cVelocity, cEquilibrium, delta, springFrequency, springDampingRatio)
	
