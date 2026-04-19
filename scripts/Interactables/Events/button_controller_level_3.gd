extends Node3D

@onready var door_3: StaticBody3D = $"../Door3"


func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
			
		door_3.locked = false
