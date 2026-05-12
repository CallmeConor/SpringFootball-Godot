extends CharacterBody2D

@export var speed = 500

@export var movement_lean_factor = 0.0

@export var pokeForce: float = 15

@export var use_fast_spring_motion: bool = false

@export var spring: SpringData

func _process(delta: float):
	input_handling(delta)
	update_visuals(delta)

func _physics_process(_delta: float):
	move_and_slide()
	spring.AddVelocity(-velocity.x * _delta * movement_lean_factor)
	simulate_spring_motion(_delta)

func input_handling(_delta: float):
	if Input.is_action_just_pressed("poke"):
		print("poke")
		spring.AddVelocity(pokeForce)

	velocity = Vector2(Input.get_axis("move_left", "move_right") * speed, 0);

func update_visuals(_delta):
	var children = get_all_children($BodyBase)

	var rotFactor = spring.GetPosition() / children.size();

	global_rotation = rotFactor

	for c in children:
		c.rotation = rotFactor

func simulate_spring_motion(delta: float):
	if use_fast_spring_motion:
		SpringMotion.calc_damped_simple_harmonic_motion_fast(spring, delta)
	else:
		SpringMotion.calc_damped_simple_harmonic_motion(spring, delta)

func get_all_children(node:Node) -> Array:
	var all_children := []
	for child in node.get_children():
		all_children.append(child)
		for grand_child in get_all_children(child):
			all_children.append(grand_child)

	return all_children
