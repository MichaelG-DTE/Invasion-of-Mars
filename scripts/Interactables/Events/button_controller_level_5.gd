extends Node3D

var all_buttons_pressed = false

func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
			
		all_buttons_pressed = true
