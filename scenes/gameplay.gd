extends Node2D

var ball_scene: PackedScene = load("res://scenes/ball.tscn")
@export var ball_in_play: Ball = null

signal ball_killed

func _ready():
	spawn_new_ball()

func spawn_new_ball():
	ball_in_play = ball_scene.instantiate()
	$Balls.add_child(ball_in_play)
	ball_in_play.position = Vector2(get_viewport_rect().size.x * 0.5, 0)
	_freeze_ball_in_play()

func _on_kill_floor_killed_ball() -> void:
	ball_in_play.free()
	call_deferred("spawn_new_ball")
	ball_killed.emit()

func _on_player_full_lean() -> void:
	_release_frozen_ball()

func _freeze_ball_in_play():
	ball_in_play.freeze = true

func _release_frozen_ball():
	ball_in_play.freeze = false
