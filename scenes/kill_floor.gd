extends Area2D

signal killed_ball

func _on_body_entered(body: Node2D) -> void:
	print("body entered the kill_floor ! ", body.name)
	killed_ball.emit()
