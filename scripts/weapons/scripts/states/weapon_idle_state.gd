extends WeaponState

func _on_idle_state_state_processing(_delta: float) -> void:
	if not weapon_controller:
		return
		
	# check for fire input
	if Input.is_action_just_pressed("fire") and weapon_controller.can_fire():
		weapon_controller.weapon_state_chart.send_event("OnFiring")

	
	# check if ammo is empty
	if not weapon_controller.has_ammo():
		weapon_controller.weapon_state_chart.send_event("OnEmpty")
