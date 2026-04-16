extends StaticBody3D

@onready var animation_player_4: AnimationPlayer = $AnimationPlayer4


var has_pressed = false

func interact():
	if not has_pressed:
		animation_player_4.play("pressed")
		has_pressed = true
