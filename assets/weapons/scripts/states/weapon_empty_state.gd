extends WeaponState


func _on_empty_state_state_entered() -> void:
	print("no bullet")
	

func _on_empty_state_state_processing(_delta: float) -> void:
	if not weapon_controller.has_ammo():
		weapon_controller.reload_weapon()
	# player instanced reload will have to be a seperate state with animation 
