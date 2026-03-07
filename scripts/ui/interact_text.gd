extends Label



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Press " + "'" + get_key_name() + "'" + " to interact"

func get_key_name():
	return str(InputMap.action_get_events("Interact")[0].as_text())
