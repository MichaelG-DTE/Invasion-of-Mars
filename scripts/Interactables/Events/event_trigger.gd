extends Area3D


var player = Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player.trigger()
