extends CharacterBody2D

enum Lean_Direction {
LEFT = -1,
RIGHT = 1
}

@export var speed = 500

@export_range(0.0, 15.0, 0.1) var movement_lean_angle = 0.0

@export var poke_force: float = 15
@export var max_fling_force : float = -1500

@export var use_fast_spring_motion: bool = false

var head = null

@export var spring: SpringData

var time_charge_started :float = 0.0
var charge_held_time :float = 0.0
@export var max_charge_hold_time : float = 1.0
@export var min_lean_applied_on_charge :float = 15.0
@export var max_lean_applied_on_charge :float = 30.0

@export var bullet_header_time : float = 2.0

@export var ball_fling_multiplier : float = 2.0

signal ready_to_serve
var has_served: bool = false
@export_range(0.0, 1.0, 0.1) var serve_ready_factor: float = 0.8

func _ready() -> void:
	var children = _get_all_children($BodyBase)
	head = children[children.size() - 1]

func _process(delta: float):
	_process_charge_time(delta)
	_update_visuals(delta)

func _physics_process(_delta: float):
	move_and_slide()
	if _charge_held_time_normalised() <= 0.0:
		spring.cEquilibrium = ((abs(velocity.x) / speed) * movement_lean_angle * -velocity.normalized().x)
	_simulate_spring_motion(_delta)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		var xNorm = event.position.x / get_viewport().get_visible_rect().size.x
		var xDir = xNorm * 2.0 - 1
		velocity = Vector2.RIGHT * xDir * speed  
		if event.double_tap:
			spring.AddVelocity(poke_force)
	
	if event is InputEventKey:
		velocity = Vector2.RIGHT * Input.get_axis("move_left", "move_right") * speed
	
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT: 
			velocity = Vector2.LEFT * speed
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			velocity = Vector2.RIGHT * speed
	
	else:
		velocity = Vector2.ZERO

func _process_charge_time(delta:float):
	if Input.is_action_just_pressed("move_up"):
		charge_held_time = _calculate_charge_held_start_time()
		_calculate_charge_held_lean(0.0, Lean_Direction.RIGHT)
	elif Input.is_action_pressed("move_up"):
		_calculate_charge_held_lean(delta, Lean_Direction.RIGHT)
		_signal_ready_to_serve()
	elif Input.is_action_just_released("move_up"):
		apply_fling_force_on_charge_released(Lean_Direction.RIGHT)

	if Input.is_action_just_pressed("move_down"):
		charge_held_time = _calculate_charge_held_start_time()
		_calculate_charge_held_lean(0.0, Lean_Direction.LEFT)
	elif Input.is_action_pressed("move_down"):
		_calculate_charge_held_lean(delta, Lean_Direction.LEFT)
		_signal_ready_to_serve()
	elif Input.is_action_just_released("move_down"):
		apply_fling_force_on_charge_released(Lean_Direction.LEFT)

func _update_visuals(_delta):
	var children = _get_all_children($BodyBase)
	var rotFactor = spring.GetPosition() / children.size();
	for c in children:
		c.rotation = deg_to_rad(rotFactor)

func _simulate_spring_motion(delta: float):
	if use_fast_spring_motion:
		SpringMotion.calc_damped_simple_harmonic_motion_fast(spring, delta)
	else:
		SpringMotion.calc_damped_simple_harmonic_motion(spring, delta)

func _get_all_children(node:Node2D) -> Array:
	var all_children := []
	for child in node.get_children():
		if child is Sprite2D:
			all_children.append(child)
		for grand_child in _get_all_children(child):
			all_children.append(grand_child)

	return all_children

func _on_head_entered(body: Node2D) -> void:
	# FIGURE OUT HOW TO CANCEL A HELD INPUT FROM HERE SO THE FLING ALWAYS APPLIES IMMEDIATELY
	#_apply_bullet_header_time()
	if body is Ball:
		var direction : Vector2 = body.global_position - head.global_position
		body.linear_velocity = direction.normalized() * abs(spring.cVelocity) * ball_fling_multiplier

func _charge_held_time_normalised() -> float:
	return charge_held_time / max_charge_hold_time

func _calculate_charge_held_start_time() -> float:
	var total_max_lean : float = min_lean_applied_on_charge + max_lean_applied_on_charge
	return (min_lean_applied_on_charge/total_max_lean) * max_charge_hold_time

func _calculate_charge_held_lean(delta:float, direction:Lean_Direction):
	charge_held_time = clamp(charge_held_time + delta, 0.0, max_charge_hold_time)
	spring.cEquilibrium = (min_lean_applied_on_charge + (_charge_held_time_normalised() * max_lean_applied_on_charge)) * direction

func apply_fling_force_on_charge_released(direction:Lean_Direction):
	spring.cEquilibrium = 0.0
	spring.AddVelocity(-max_fling_force * _charge_held_time_normalised() * direction)
	charge_held_time = 0.0

func _apply_bullet_header_time():
	var bullet_time_modifier = clamp(abs(spring.cVelocity / max_fling_force), 0, 1)
	var bullet_time_adjusted = bullet_header_time * bullet_time_modifier
	if (bullet_time_adjusted >0.2):
		$BulletHeaderTimer.start(bullet_time_adjusted)
		Engine.time_scale = 0.2

func _on_bullet_header_timeout() -> void:
	Engine.time_scale = 1.0

func _on_gameplay_ball_killed() -> void:
	has_served = false

func _signal_ready_to_serve():
	if _charge_held_time_normalised() >= 0.8 && !has_served:
		ready_to_serve.emit()
		has_served = true
