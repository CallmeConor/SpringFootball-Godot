extends RigidBody2D

class_name Ball

signal ball_entered_node(node: Node)

func _on_body_entered(body: Node) -> void:
	ball_entered_node.emit(body)
