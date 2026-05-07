class_name GroundedState extends PlayerState

# checks if the player is on the ground and checks for jump input

func _on_grounded_state_physics_processing(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump") and player_controller.is_on_floor():
		player_controller.jump()
		player_controller.state_chart.send_event("OnAirborne")

	if not player_controller.is_on_floor():
		player_controller.state_chart.send_event("OnAirborne")
