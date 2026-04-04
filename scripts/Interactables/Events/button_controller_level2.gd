extends Node3D

@onready var first_button_level_2: StaticBody3D = $FirstButtonLevel2
@onready var second_button_level_2: StaticBody3D = $SecondButtonLevel2
@onready var door: StaticBody3D = $"../Door"

func _process(_delta: float) -> void:
	if first_button_level_2.has_pressed == true and second_button_level_2.has_pressed == true:
		door.locked = false
