extends Node2D

var ball_scene: PackedScene = load("res://scenes/ball.tscn")
@export var ball_in_play: Ball = null

func _ready():
	spawn_new_ball()

func spawn_new_ball():
	ball_in_play = ball_scene.instantiate()
	$Balls.add_child(ball_in_play)
	ball_in_play.position = Vector2(get_viewport_rect().size.x * 0.5, 0)
	pass

func _on_kill_floor_killed_ball() -> void:
	print("Killed ball! Spawn new ball!!")
	ball_in_play.free()
	call_deferred("spawn_new_ball")
