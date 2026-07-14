extends Control

@onready var player_scores: Array[RichTextLabel] = [%Player_Score_1, %Player_Score_2]

func _ready():
	for score in player_scores:
		score.text = str(0)

func _update_score(index : int, score_value: int):
	player_scores[index].text = str(score_value) 
