class_name AirborneState extends PlayerState

func _on_airborne_state_physics_processing(_delta: float) -> void:
	# checks whether player is in the air or not
	if player_controller.is_on_floor():
		if player_controller.check_fall_speed():
			# if the player hits the floor after being in the air, then add camera effect
			player_controller.camera_effects.add_fall_kick(2.0)
		player_controller.state_chart.send_event("OnGrounded")
	
	player_controller.current_fall_velocity = player_controller.velocity.y
