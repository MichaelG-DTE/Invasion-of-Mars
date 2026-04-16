extends StaticBody3D

@onready var animation_player_7: AnimationPlayer = $AnimationPlayer7

var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_7.play("pressed")
		has_pressed = true
