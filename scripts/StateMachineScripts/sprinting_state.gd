class_name sprinting_state extends PlayerState

func _on_sprinting_state_physics_processing(_delta: float) -> void:
	if not Input.is_action_pressed("Sprint"):
		player_controller.state_chart.send_event("OnWalking")

func _on_sprinting_state_entered() -> void:
	player_controller.sprint()
