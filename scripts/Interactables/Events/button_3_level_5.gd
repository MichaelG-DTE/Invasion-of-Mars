extends StaticBody3D

@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3

var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_3.play("pressed")
		has_pressed = true
