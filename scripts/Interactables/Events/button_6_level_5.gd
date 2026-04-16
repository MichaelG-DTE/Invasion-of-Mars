extends StaticBody3D

@onready var animation_player_6: AnimationPlayer = $AnimationPlayer6


var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_6.play("pressed")
		has_pressed = true
