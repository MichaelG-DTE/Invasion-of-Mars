extends WeaponState


func _on_firing_state_state_entered() -> void:
	if not weapon_controller:
		return
	
	weapon_controller.fire_weapon()
	

func _on_firing_state_state_physics_processing(_delta: float) -> void:
	if not weapon_controller:
		return
		
	# check if ammo is empty
	if not weapon_controller.has_ammo():
		weapon_controller.weapon_state_chart.send_event("OnEmpty")
		return
		
	if weapon_controller.current_weapon.is_automatic:
		# automatic fire
		if Input.is_action_pressed("fire"):
			if weapon_controller.can_fire():
				weapon_controller.fire_weapon()
				
		else:
			# when trigger released 
			weapon_controller.weapon_state_chart.send_event("OnIdle")
	else:
		# single fire 
		weapon_controller.weapon_state_chart.send_event("OnIdle")
	
