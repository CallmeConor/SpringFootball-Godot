extends Node2D

var ball_scene: PackedScene = load("res://scenes/ball.tscn")
@export var ball_in_play: Ball = null

@export var player_scenes: PackedScene

signal ball_killed
signal ball_spawned(Ball)

var player_last_touched_ball: Player
var player_served_correctly: bool

@onready var bouncy_walls: Array = [%BouncyWall, %BouncyWall2, %BouncyWall3]

@onready var score_canvas: Control = $Score_Canvas

@onready var players: Array[Player] = [$Player]
@onready var player_scores: Array[int] = [0]

var ball_count: int

func _ready():
	ball_count = 0
	_spawn_new_ball()

func _spawn_new_ball():
	ball_count += 1
	player_last_touched_ball = null
	player_served_correctly = false
	
	ball_in_play = ball_scene.instantiate()
	ball_in_play.ball_entered_node.connect(_on_ball_entered)
	ball_in_play.position = Vector2(get_viewport_rect().size.x * 0.5, 64)
	$Balls.add_child(ball_in_play)
	
	_freeze_ball_in_play()
	ball_spawned.emit(ball_in_play)

func _score_players():
	print("Scores players for ball: ", ball_count)
	if player_last_touched_ball != null and player_served_correctly:
		for i in players.size():
			if players[i] == player_last_touched_ball:
				player_scores[i] += 1
				score_canvas._update_score(i, player_scores[i])
				break
		print("Player that scored! ", player_last_touched_ball.name)
	else:
		print("No player had touched the ball")

func _freeze_ball_in_play():
	ball_in_play.freeze = true

func _release_frozen_ball():
	ball_in_play.freeze = false

# Signal listeners
func _on_kill_floor_killed_ball():
	ball_in_play.ball_entered_node.disconnect(_on_ball_entered)
	ball_in_play.free()
	ball_killed.emit()
	
	_score_players()
	
	_spawn_new_ball.call_deferred()

func _on_player_ready_to_serve():
	_release_frozen_ball()

func _on_player_headed_the_ball(player: Player):
	print("Ball headed by a player")
	player_last_touched_ball = player

func _on_ball_entered(node : Node):
	if node is Player or node.owner is Player:
		print("Ball hit a player")
		return
	
	if bouncy_walls.has(node) or bouncy_walls.has(node.owner):
		print("Ball hit a wall")
		player_served_correctly = player_last_touched_ball != null
		return
	
	print("Ball hit something else: ", node.name, " owned by: ", node.owner.name)
