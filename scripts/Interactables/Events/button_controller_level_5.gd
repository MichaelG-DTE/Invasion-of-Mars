extends Node3D

@onready var button_level_5: StaticBody3D = $ButtonLevel5
@onready var button_2_level_5: StaticBody3D = $Button2Level5
@onready var button_3_level_5: StaticBody3D = $Button3Level5
@onready var button_4_level_5: StaticBody3D = $Button4Level5
@onready var button_5_level_5: StaticBody3D = $Button5Level5
@onready var button_6_level_5: StaticBody3D = $Button6Level5
@onready var button_7_level_5: StaticBody3D = $Button7Level5
@onready var button_8_level_5: StaticBody3D = $Button8Level5

var all_buttons_pressed = false

func _process(_delta: float) -> void:
	if button_level_5.has_pressed == true and button_2_level_5.has_pressed == true and button_3_level_5.has_pressed == true and button_4_level_5.has_pressed == true and button_5_level_5.has_pressed == true and button_6_level_5.has_pressed == true and button_7_level_5.has_pressed == true and button_8_level_5.has_pressed == true:
		all_buttons_pressed = true
		
