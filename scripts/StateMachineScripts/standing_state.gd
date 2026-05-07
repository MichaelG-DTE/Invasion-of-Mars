class_name StandingState extends PlayerState

# checks if the player is standing or crouching 
func _on_standing_state_physics_processing(delta: float) -> void:
	player_controller.camera.update_camera_height(delta, 1)
	
	if Input.is_action_pressed("Crouch") and player_controller.is_on_floor():
		player_controller.state_chart.send_event("OnCrouching")

func _on_standing_state_entered() -> void:
	player_controller.stand()
