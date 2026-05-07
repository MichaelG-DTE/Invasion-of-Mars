extends Node3D

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# signals level change when the player enters the teleporter
func _on_area_3d_body_entered(body: Node3D) -> void:
	if globalvar.can_teleport == true:
		if body.is_in_group("player"):
			globalvar.current_level += 1
			SignalBus.level_change.emit()
