extends Node3D

@onready var firstbutton_level_3: StaticBody3D = $FirstbuttonLevel3
@onready var door_3: StaticBody3D = $"../Door3"


func _process(_delta: float) -> void:
	if firstbutton_level_3.has_pressed == true:
		door_3.locked = false
