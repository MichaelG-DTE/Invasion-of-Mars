extends Label


# allows for changing the keybind of the interact key without the text still saying 'e'

func _process(_delta: float) -> void:
	text = "Press " + "'" + get_key_name() + "'" + " to interact"

func get_key_name():
	return str(InputMap.action_get_events("Interact")[0].as_text())
