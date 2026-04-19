extends Node3D


@onready var door: StaticBody3D = $"../Door"

func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
			
		door.locked = false
