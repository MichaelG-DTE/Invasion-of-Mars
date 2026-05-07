class_name walking_state extends PlayerState

# checks if sprinting or walking
func _on_walking_state_physics_processing(_delta: float) -> void:
	if Input.is_action_pressed("Sprint"):
		player_controller.state_chart.send_event("OnSprinting")


func _on_walking_state_entered() -> void:
	player_controller.walk()
	
