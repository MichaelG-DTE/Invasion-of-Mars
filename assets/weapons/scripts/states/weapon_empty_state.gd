extends WeaponState


func _on_empty_state_state_entered() -> void:
	print("no bullet")
	

func _on_empty_state_state_processing(_delta: float) -> void:
	# add reload functionality - automatic reload
	# player instanced reload will have to be a seperate state with animation 
	pass
