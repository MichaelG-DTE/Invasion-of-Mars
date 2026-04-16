extends StaticBody3D


@onready var animation_player_5: AnimationPlayer = $AnimationPlayer5

var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_5.play("pressed")
		has_pressed = true
