extends Node3D

var player
@onready var new_player_position: Marker3D = $"../Geometry/Epilogue/NewPlayerPosition"

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if globalvar.can_teleport == true:
		if body.is_in_group("player"):
			globalvar.current_level += 1
			if !globalvar.current_level == 5:
				SignalBus.level_change.emit()
	if globalvar.current_level == 5 and globalvar.can_teleport == true:
		player.global_position = new_player_position.global_position
