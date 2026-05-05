extends Node3D


func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
			
		var door = get_tree().get_first_node_in_group("enddoor")
		door.locked = false
