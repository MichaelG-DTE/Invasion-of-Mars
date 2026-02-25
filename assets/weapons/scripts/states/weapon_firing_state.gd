extends WeaponState


func _on_firing_state_state_entered() -> void:
	if not weapon_controller:
		return
	
	weapon_controller.fire_weapon()
	

func _on_firing_state_state_physics_processing(_delta: float) -> void:
	if not weapon_controller:
		return
		
	# check if ammo is empty
	if weapon_controller.current_ammo <= 0:
		weapon_controller.weapon_state_chart.send_event("OnEmpty")
		return
		
	# return to idle after firing
	weapon_controller.weapon_state_chart.send_event("OnIdle") 
