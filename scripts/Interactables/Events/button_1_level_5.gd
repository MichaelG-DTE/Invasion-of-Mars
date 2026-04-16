extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_pressed = false

func interact():
	if not has_pressed:
		animation_player.play("pressed")
		has_pressed = true
