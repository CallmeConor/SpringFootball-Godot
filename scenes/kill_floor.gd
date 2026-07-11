extends Area2D

signal killed_ball

func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		killed_ball.emit()
