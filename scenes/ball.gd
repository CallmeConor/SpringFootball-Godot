extends RigidBody2D

class_name Ball

func _on_body_entered(body: Node) -> void:
	print("Body entered the ball ", body.name)
