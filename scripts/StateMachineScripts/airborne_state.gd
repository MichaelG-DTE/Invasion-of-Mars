class_name AirborneState extends PlayerState

func _on_airborne_state_processing(_delta: float) -> void:
	if player_controller.is_on_floor():
		player_controller.state_chart.send_event("OnGrounded")
