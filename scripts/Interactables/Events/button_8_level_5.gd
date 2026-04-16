extends StaticBody3D

@onready var animation_player_8: AnimationPlayer = $AnimationPlayer8

var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_8.play("pressed")
		has_pressed = true
