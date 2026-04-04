extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if globalvar.can_teleport == true:
		if body.is_in_group("player"):
			SignalBus.level_change.emit()
