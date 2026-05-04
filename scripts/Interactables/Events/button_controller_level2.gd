extends Node3D

var door

func _ready() -> void:
	find_the_stupid_door()

func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
		find_the_stupid_door()
		door.locked = false
		
		
func find_the_stupid_door():
	var doors = get_tree().get_nodes_in_group("door")
	for neodoor in doors:
		if neodoor == null:
			return
		else:
			door = neodoor
